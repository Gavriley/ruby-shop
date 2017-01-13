module Admin
  # top-level class documentation comment
  class OrdersController < Admin::AdminController
    before_action :set_order, only: [:show, :destroy]

    def index
      @title = 'Замовлення'
      set_orders

      respond_to do |format|
        format.html { render :index }
        format.js { render :orders }
      end
    end

    def show
      @title = "Замовлення №#{@order.id}"
      @order.set_off_unverified
    end

    def destroy
      @order.destroy
      set_orders
      redirect_to admin_orders_path
    end

    private

    def set_orders
      @orders = Order.latest.page(params[:page])
    end

    def set_order
      @order = Order.includes(line_items: :product).find(params[:id])
    end
  end
end
