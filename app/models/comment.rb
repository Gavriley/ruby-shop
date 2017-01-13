class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  scope :latest, -> { includes(:user).includes(:product).order(created_at: :desc) }

  validates :user, presence: { message: 'Помилка при добавленні товару' }
  validates :product, presence: { message: 'Помилка при добавленні товару' }
  validates :content, presence: { message: 'Заповніть контент коментаря' }, length: { maximum: 1000, message: 'Максимальна довжина коментаря 1000 символів' }
end
