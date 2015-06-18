class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.text :title, null: false
      t.text :description
      t.decimal :price, null: false
      t.integer :amount, null: false
      t.references :author, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
