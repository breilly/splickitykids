class AddAccountActiveFieldToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :account_active, :boolean, default: false
  end
end
