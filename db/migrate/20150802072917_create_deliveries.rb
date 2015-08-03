class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.string :description
      t.decimal :price, precision: 9, scale: 2

      t.timestamps null: false
    end
  end
end
