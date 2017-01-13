class Order < ActiveRecord::Base
  include AASM

  has_many :line_items, dependent: :destroy

  # attr_accessor :liqpay_form

  # def as_json(options={})
  #   super(:include => [:liqpay_form])
  # end

  scope :latest, -> { order(updated_at: :desc) }

  validates :email, presence: { message: 'Заповніть поле e-mail' }, length: { maximum: 60, message: 'e-mail може містити максимум 60 символів' }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'Некоректний e-mail' }
  validates :name, presence: { message: 'Заповніть поле імя' }, length: { maximum: 50, message: 'Імя може містити максимум 50 символів' }
  validates :address, presence: { message: 'Заповніть поле адреса' }, length: { maximum: 255, message: 'Адреса може містити максимум 255 символів' }

  def self.pay_logger
    @@pay_logger ||= Logger.new("#{Rails.root}/log/pay.log")
  end

  def add_line_items_from_cart(cart)
    cart.line_items.each do |line_item|
      line_item.cart_id = nil
      line_items << line_item
    end
  end

  def set_on_unverified
    update(unverified: true)
  end

  def set_off_unverified
    update_column(:unverified, false)
  end

  def get_last_error
    return "(#{last_error})" if last_error
  end

  def has_line_items?
    line_items.any?
  end

  def has_correct_amount_price?
    !amount.nil? && (amount > 0.01)
  end

  aasm do
    state :pending, initial: true
    state :process, :sandbox, :failure

    after_all_transitions :set_on_unverified

    event :process, after: -> { EmailWorker.perform_async(id, 'process') } do
      transitions from: :pending, to: :process, guard: [:has_line_items?, :has_correct_amount_price?]
    end

    event :sandbox, after: -> { EmailWorker.perform_async(id, 'success') } do
      transitions from: :process, to: :sandbox
    end

    event :failure, after: -> { EmailWorker.perform_async(id, 'error') } do
      transitions from: :process, to: :failure
    end
  end
end
