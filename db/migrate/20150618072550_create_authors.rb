class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.text :firstname, null: false
      t.text :lastname, null: false
      t.text :biography

      t.timestamps null: false
    end
  end
end
