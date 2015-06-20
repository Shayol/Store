class CreateRaitings < ActiveRecord::Migration
  def change
    create_table :raitings do |t|
      t.text :review
      t.integer :raiting_number
      t.references :customer, index: true, foreign_key: true
      t.references :book, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
