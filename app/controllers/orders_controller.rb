require 'json'

# top-level class documentation comment
class OrdersController < ApplicationController
  load_and_authorize_resource except: [:liqpay_response, :paypal_response, :stripe_response]
  # skip_before_filter :verify_authenticity_token
  before_action :set_order, only: [:show, :stripe_response]
  rescue_from AASM::InvalidTransition,
              with: -> {
                      redirect_to root_path,
                                  notice: 'Помилка при формуванні заказу'
                    }

  def show
    raise ActiveRecord::RecordNotFound unless @order.process?
    @liqpay = create_liqpay
    @paypal = create_paypal
  end

  def create
    @cart = Cart.find(cookies[:cart_id])
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.valid?
        handle_created_order
        format.js { redirect_to @order }
      else
        format.js
      end
    end
  end

  def modal
    @order = Order.new
    render :modal, format: :js
  end

  def liqpay_response
    order_params = JSON.parse(Base64.decode64(params['data']))
    @order = Order.find(order_params['order_id'].split(', ').first)
    if order_params['err_description']
      @order.last_error =
        order_params['err_description']
    end
    @order.update_column(:pay_with, 'Liqpay')

    case order_params['status']
    when 'sandbox'
      @order.sandbox!
      Order.pay_logger.info("Заказ №#{@order.id} успішно оплачений")
    else
      @order.failure!
      Order.pay_logger
           .error(
             "В оплаті заказу №#{@order.id} сталася помилка #{@order.get_last_error}"
           )
    end

    render nothing: true
  end

  def paypal_response    
    invoice = params[:invoice].split(', ')
    @order = Order.find(invoice.first)
    @order.update_column(:pay_with, 'PayPal')

    case params[:payment_status]
    when 'Completed'
      @order.sandbox!
      Order.pay_logger.info("Заказ №#{@order.id} успішно оплачений")
    else
      @order.failure!
      Order.pay_logger.error("В оплаті заказу №#{@order.id} сталася помилка")
    end

    render nothing: true
  end

  def stripe_response
    create_stripe
    Order.pay_logger.info("Заказ №#{@order.id} успішно оплачений")
    redirect_to products_path, notice: 'Товари успішно оплачені'
  rescue => error
    @order.last_error = error.message
    @order.failure!
    Order.pay_logger
         .error(
           "В оплаті заказу №#{@order.id} сталася помилка #{@order.get_last_error}"
         )
    redirect_to products_path, notice: 'Помилка при оплаті'
  end

  private

  def order_params
    params.require(:order).permit(:email, :name, :address)
  end

  def set_order
    @order = Order.includes(line_items: :product).find(params[:id])
  end

  def handle_created_order
    @order.add_line_items_from_cart(@cart)
    @order.amount = @cart.total_price

    @order.process
    @order.save

    Cart.destroy(cookies[:cart_id])
    cookies.delete(:cart_id)

    Order.pay_logger.info("Новий заказ №#{@order.id} находиться в очікуванні")
  end

  def create_stripe
    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      source: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: @order.amount * 100,
      description: "Заказ №#{@order.id}",
      currency: 'UAH'
    )

    @order.update_column(:pay_with, 'Stripe')
    @order.sandbox!
  end

  def create_liqpay
    liqpay_params = {
      action: 'pay',
      sandbox: '1',
      amount: @order.amount,
      currency: 'UAH',
      description: "Заказ №#{@order.id}",
      order_id: "#{@order.id}, #{@order.created_at.strftime("%H:%M:%S").to_s}",
      version: '3',
      server_url: liqpay_response_orders_url
    }

    Liqpay::Liqpay.new.cnb_form(liqpay_params).html_safe
  end

  def create_paypal
    values = {
      business: 'gavrileypetro-facilitator@gmail.com',
      cmd: '_cart',
      upload: 1,
      notify_url: paypal_response_orders_url,
      invoice: "#{@order.id}, #{@order.created_at.strftime("%H:%M:%S").to_s}"
    }

    @order.line_items.each_with_index do |item, index|
      values.merge!("amount_#{index + 1}" => item.product.price,
                    "item_name_#{index + 1}" => item.product.title,
                    "item_number_#{index + 1}" => item.id,
                    "quantity_#{index + 1}" => item.count)
    end

    'https://www.sandbox.paypal.com/cgi-bin/webscr?' + values.to_query
  end
end
