class Category < ActiveRecord::Base
  before_save -> { self.parent_id = 0 if parent_id.nil? }
  before_destroy :set_parent_to_children
  after_update :check_children_categories

  has_many :categories_products
  has_many :products, -> { order(created_at: :desc) }, through: :categories_products
  has_many :children, class_name: 'Category', foreign_key: :parent_id

  belongs_to :parent, class_name: 'Category', foreign_key: :parent_id

  validates :name, presence: { message: 'Заповніть поле назва' }, length: { maximum: 40, message: 'Назва може містити максимум 40 символів' }

  def category_products
    Product.joins(:categories).where(['categories.id = %d OR parent_id = %d', id, id]).distinct.order(created_at: :desc)
  end

  def set_parent_to_children
    children.each { |child| child.update_column(:parent_id, 0) }
  end

  def check_children_categories
    set_parent_to_children if parent_id != 0 && children.exists?
  end

  def products_count
    Product.joins(:categories).where(['categories.id = %d OR parent_id = %d', id, id]).distinct.count
  end

  def self.parent_categories
    Category.includes(:children).where(parent_id: 0).order(id: :desc)
  end  
end
