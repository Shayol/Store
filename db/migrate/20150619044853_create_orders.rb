class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal :total_price, null: false, default: 0
      t.datetime :completed_date
      t.string :state, null: false, default: "in_progress"
      t.references :user, index: true, foreign_key: true
      t.references :credit_card, index: true, foreign_key: true
      t.integer :billing_address_id
      t.integer :shipping_address_id

      t.timestamps null: false
    end
  end
end
