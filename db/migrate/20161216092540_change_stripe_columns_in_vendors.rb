class ChangeStripeColumnsInVendors < ActiveRecord::Migration
  def change
    remove_column :vendors, :publishable_key, :string
    remove_column :vendors, :provider, :string
    remove_column :vendors, :uid, :string
    remove_column :vendors, :access_code, :string

    add_column :vendors, :stripe_publishable_key, :string
    add_column :vendors, :stripe_provider, :string
    add_column :vendors, :stripe_account_id, :string
    add_column :vendors, :stripe_token, :string
    add_column :vendors, :stripe_refresh_token, :string
    add_column :vendors, :stripe_business_name, :string
    add_column :vendors, :stripe_account_name, :string
  end
end
