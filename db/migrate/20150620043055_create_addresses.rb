class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.text :address
      t.text :zipcode
      t.text :city
      t.text :phone
      t.string :country

      t.timestamps null: false
    end
  end
end
