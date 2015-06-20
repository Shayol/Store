class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.text :email, null: false
      t.text :password, null: false
      t.text :firstname, null: false
      t.text :lastname, null: false

      t.timestamps null: false
    end
    add_index :customers, :email, unique: true
  end
end