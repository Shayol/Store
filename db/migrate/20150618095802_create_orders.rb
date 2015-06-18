class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal :total_price, null: false
      t.datetime :completed_date, null: false
      t.string :state, null: false, default: "in progress"
      t.references :customer, index: true, foreign_key: true
      t.references :credit_card, index: true, foreign_key: true
      t.references :billing_address, index: true, foreign_key: true
      t.references :shipping_address, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
