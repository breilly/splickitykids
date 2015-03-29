class AddSpotsAddressCityStateZipToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :spots, :integer
    add_column :activities, :address, :string
    add_column :activities, :city, :string
    add_column :activities, :state, :string
    add_column :activities, :zip_code, :string
  end
end
