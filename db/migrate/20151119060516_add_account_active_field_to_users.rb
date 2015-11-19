class AddAccountActiveFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_active, :boolean, default: false
  end
end
