class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.text :firstname
      t.text :lastname
      t.text :biography

      t.timestamps null: false
    end
  end
end
