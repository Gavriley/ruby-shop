# top-level class documentation comment
module ApplicationHelper
  @@helper = ActionController::Base.helpers

  def get_comment_info(_product)
    comments_count = @product.comments.count
    'На сторінці ' +
      (!comments_count.zero? ? 'присутні ' +
        plural_form(comments_count, %w(відгук відгуки відгуків)) :
        'відсутні відгуки')
  end

  def create_search_query(products)
    if products.present?
      query = products.map do |product|
        @@helper.content_tag('li',
                             @@helper.link_to(product.title,
                                              product_path(product)))
      end

      @@helper.content_tag('ul', query.join.html_safe)
    end
  end

  def get_params_cart
    if cookies[:cart_id].present?
      begin
        cart = Cart.find(cookies[:cart_id])
        cart_count = cart.total_count
        cart_price = cart.total_price
      rescue ActiveRecord::RecordNotFound
        cookies.delete(:cart_id)
        
        cart_count = 0
        cart_price = 0
      end
    else
      cart_count = 0
      cart_price = 0
    end

    %(#{cart_count}шт. - #{@@helper.number_to_currency(cart_price, unit: ' грн.', separator: '.', delimiter: ' ', format: '%n %u')})
  end

  def get_title
    'Shop' + (@title.present? ? " | #{@title}" : '')
  end

  def set_month(month)
    month_names =
      %w(Січня Лютого Березня Квітня Травня
         Червня Липня Серпня Вересня Жовтня Листопада Грудня)
    month_names[month - 1]
  end

  def plural_form(number, array_str)
    cases = [2, 0, 1, 1, 1, 2]
    number.to_s + ' ' +
      array_str[number % 100 > 4 && number % 100 < 20 ? 2 :
        cases[[number % 10, 5].min]]
  end

  def get_error_messages(object)
    return '' if object.errors.empty?

    list = object.errors.messages.map do |_key, msg|
      @@helper.content_tag('li', msg.first)
    end

    messages = @@helper.content_tag('ul', list.join.html_safe)
    title = @@helper.content_tag('h4',
                                 "Виправте #{plural_form(object.errors.count, %w(помилку помилки помилок))}: ")

    @@helper.content_tag('div class=error-messages', title + messages)
  end

  def get_notice
    return '' if notice.nil?
    "<div id=notice>#{notice}</div>".html_safe
  end

  def get_alert
    return '' if flash[:alert].nil?
    "<div id=alert>#{flash[:alert]}</div>".html_safe
  end

  def get_orders_unverified_count
    @orders_count = Order.where(unverified: true).count if @orders_count.nil?

    if @orders_count.zero?
      return ''
    else
      return "<span class='order-counter'>#{@orders_count}</span>".html_safe
    end
  end

  def set_cart_params
    if session[:cart_id]
      @cart_count = Cart.find(session[:cart_id]).total_count
      @cart_price = Cart.find(session[:cart_id]).total_price
    else
      @cart_count = 0
      @cart_price = 0.00
    end
  end
end
