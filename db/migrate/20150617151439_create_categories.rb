class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.text :title, null: false, unique: true

      t.timestamps null: false
    end
    add_index :categories, :title, unique: true
  end
end
