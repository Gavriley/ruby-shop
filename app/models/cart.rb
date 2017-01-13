class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy

  def add_products(product, count = 1)
    item = line_items.find_by(product_id: product)

    if item
      item.count += count
    else
      item = line_items.build(product_id: product)
      item.count = count
    end

    item
  end

  def total_price
    line_items.to_a.sum(&:total_price)
  end

  def total_count
    line_items.to_a.sum(&:count)
  end
end
