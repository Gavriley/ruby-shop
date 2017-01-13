class Products < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title, null: false, default: '', limit: 70
      t.text :description, default: '', limit: 2000
      t.attachment :thumbnail
      t.decimal :price, precision: 8, scale: 2, null: false
      t.belongs_to :user, index: true
      t.boolean :published, null: false, default: true
      t.timestamps null: false
    end
  end
end
