class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.text :number
      t.integer :expiration_year
      t.text :firstname
      t.text :lastname
      t.text :CVV
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
