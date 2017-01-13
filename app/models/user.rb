class User < ActiveRecord::Base
  has_many :products
  has_many :comments, dependent: :destroy
  has_attached_file :avatar, styles: { full: '150x150>', comment: '70x70>' }

  after_validation :clean_avatar_errors

  scope :latest, -> { order(created_at: :desc) }
  
  attr_accessor :only_avatar

  belongs_to :role

  def avatar_validator
    self.only_avatar = true

    def email_required?
      false
    end

    def password_required?
      false
    end
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_validation -> { login.strip!; name.strip! }, unless: :only_avatar

  validates :login, uniqueness: { message: 'Логін вже використовується' }, format: { with: /\A[a-zA-Z0-9\-\_]+\z/, multiline: true, message: 'В логіні присутні недопустимі символи' },
                    length: { maximum: 25, message: 'Максимальний розмір логіна 25 символів' }, presence: { message: 'Заповніть поле логін' }, unless: :only_avatar
  validates :name, length: { maximum: 50, message: 'Максимальний розмір імені 50 символів' }, presence: { message: 'Заповніть поле імя' }, unless: :only_avatar

  validates_attachment :avatar, content_type: { content_type: ['image/jpeg', 'image/png', 'image/gif', 'image/jpg'], message: 'Некоректний формат аватару' }
  validates_with AttachmentSizeValidator, attributes: :avatar, less_than: 1.megabytes, message: 'Максимальний розмір аватару 1 мегабайт'

  after_initialize :require_email_and_password

  after_initialize -> { self.role ||= Role.find_by_name('guest') }
  before_create -> { self.role = Role.find_by_name('client') }

  def self.search(query)
    where("LOWER(users.login) LIKE LOWER(?) OR LOWER(users.name) LIKE LOWER(?)", "%#{query}%", "%#{query}%")
  end

  private

  def clean_avatar_errors
    errors.delete(:avatar)
  end

  def require_email_and_password
    def email_required?
      super
    end

    def password_required?
      super
    end
  end
end
