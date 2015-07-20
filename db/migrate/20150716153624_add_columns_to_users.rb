class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :billing_address_id, :integer
    add_column :users, :shipping_address_id, :integer
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
  end
end
