class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table(:wish_lists, :books)
  end
end
