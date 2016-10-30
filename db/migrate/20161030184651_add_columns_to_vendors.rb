class AddColumnsToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :ssn, :string
    add_column :vendors, :dob_month, :string
    add_column :vendors, :dob_day, :string
    add_column :vendors, :dob_year, :string 
    add_column :vendors, :routing_number, :string
    add_column :vendors, :account_number, :string
  end
end
