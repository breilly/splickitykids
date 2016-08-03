class AddVendorToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :vendor_id, :integer
  end
end
