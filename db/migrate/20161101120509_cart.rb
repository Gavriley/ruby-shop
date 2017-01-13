class Cart < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.timestamps null: false
    end
  end
end
