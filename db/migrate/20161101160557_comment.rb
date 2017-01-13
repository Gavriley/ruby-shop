class Comment < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content, null: false, default: '', limit: 1000
      t.belongs_to :user, index: true
      t.belongs_to :product, index: true
      t.timestamps null: false
    end
  end
end
