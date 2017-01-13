class LineItem < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.belongs_to :product, index: true
      t.belongs_to :cart, index: true
      t.belongs_to :order, index: true
      t.integer :count, default: 1
    end
  end
end
