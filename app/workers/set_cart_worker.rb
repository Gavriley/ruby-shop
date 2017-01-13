class SetCartWorker
  include Sidekiq::Worker
  include CurrentCart
  sidekiq_options queue: 'set_cart'
  sidekiq_options retry: false

  def perform(&block)
    set_cart
    yield
  end
end
