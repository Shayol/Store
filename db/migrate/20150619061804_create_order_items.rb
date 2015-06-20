class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.decimal :price, null: false
      t.integer :quantity, null: false
      t.references :book, index: true, foreign_key: true
      t.references :order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
