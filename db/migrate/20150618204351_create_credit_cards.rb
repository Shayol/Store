class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.text :number, null: false
      t.text :expiration_month, null: false
      t.integer :expiration_year, null: false
      t.text :firstname, null: false
      t.text :lastname, null: false
      t.text :CVV, null: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
