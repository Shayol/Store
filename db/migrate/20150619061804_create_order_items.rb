class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.decimal :price, null: false, precision: 9, scale: 2
      t.integer :quantity, null: false
      t.string :product_type
      t.integer :product_id
      t.references :order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
