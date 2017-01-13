class EmailWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'send_email'
  sidekiq_options retry: false

  def perform(order_id, type)
    @order = Order.find(order_id)
    case type
    when 'process'
      PaymentMailer.send_payment(@order).deliver_now
    when 'success'
      PaymentMailer.send_success_message(@order).deliver_now
    when 'error'
      PaymentMailer.send_error_message(@order).deliver_now
    end
  end
end
