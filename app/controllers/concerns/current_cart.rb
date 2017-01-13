module CurrentCart
  extend ActiveSupport::Concern

  private

  def set_cart
    @cart = Cart.find(cookies[:cart_id])
    CleanerCartWorker.cancel! cookies[:cleaner_cart_id] if cookies[:cleaner_cart_id].present?
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
  ensure
    cleaner_cart_id = CleanerCartWorker.
    perform_in(7.days, @cart.id)
    cookies[:cart_id] = { value: @cart.id, 
      expires: 7.days.from_now }
    cookies[:cleaner_cart_id] = { value: cleaner_cart_id, 
      expires: 7.days.from_now }
  end
end
