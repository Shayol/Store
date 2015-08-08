class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.text :address
      t.text :zipcode
      t.text :city
      t.text :phone
      t.references :country, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
