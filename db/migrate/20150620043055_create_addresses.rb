class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.text :address, null: false
      t.text :zipcode, null: false
      t.text :city, null: false
      t.text :phone, null: false
      t.references :country, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
