class Category < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false, default: '', limit: 40
      t.integer :parent_id, null: false, default: 0
    end
  end
end
