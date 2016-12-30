class AddStripeColumnsToVendor < ActiveRecord::Migration
  def change
    add_column :vendors, :publishable_key, :string
    add_column :vendors, :provider, :string
    add_column :vendors, :uid, :string
    add_column :vendors, :access_code, :string  
  end
end
