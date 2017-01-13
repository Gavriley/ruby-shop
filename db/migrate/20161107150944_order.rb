class Order < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :email, null: false
      t.integer :amount
      t.string :pay_with
      t.string :aasm_state
      t.string :last_error
      t.boolean :unverified, null: false, default: false
      t.timestamps null: false
    end
  end
end
