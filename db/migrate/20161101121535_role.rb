class Role < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, null: false, default: ''
      t.string :title, null: false, default: ''
    end

    add_index :roles, :name, unique: true
    add_index :roles, :title, unique: true
  end
end
