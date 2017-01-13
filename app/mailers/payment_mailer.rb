class PaymentMailer < ApplicationMailer
  def send_payment(order)
    @order = order
    mail(to: [@order.email, ENV['admin_email']], subject: 'Новий заказ')
  end

  def send_success_message(order)
    @order = order
    mail(to: [@order.email, ENV['admin_email']], subject: 'Товари успішно оплачені')
  end

  def send_error_message(order)
    @order = order
    mail(to: [@order.email, ENV['admin_email']], subject: 'Помилка при оплаті')
  end
end
