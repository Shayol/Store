class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.text :name, null: false

      t.timestamps null: false
    end
    add_index :countries, :name, unique: true
  end
end
