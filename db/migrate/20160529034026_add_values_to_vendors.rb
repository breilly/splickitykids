class AddValuesToVendors < ActiveRecord::Migration
   def change
    add_column :vendors, :company_name, :string
    add_column :vendors, :website, :string
    add_column :vendors, :ein, :string
    add_column :vendors, :account, :string
    add_column :vendors, :first_name, :string
    add_column :vendors, :last_name, :string
  end
end
