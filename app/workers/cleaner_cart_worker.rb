class CleanerCartWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'clean_cart'
  sidekiq_options retry: false

  def perform(cart_id)
    return if cancelled?
    Cart.find(cart_id).destroy
    Net::HTTP.post_form(URI.parse('http://localhost:9292/faye'), message: { channel: '/clean_cart', data: {} }.to_json)
  end

  def cancelled?
    Sidekiq.redis { |c| c.exists("cancelled-#{jid}") }
  end

  def self.cancel!(jid)
    Sidekiq.redis { |c| c.setex("cancelled-#{jid}", 86_400, 1) }
  end
end
