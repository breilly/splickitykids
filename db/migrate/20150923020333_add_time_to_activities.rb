class AddTimeToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :start_hour, :string
  	add_column :activities, :end_hour, :string
  	add_column :activities, :start_min, :string
  	add_column :activities, :end_min, :string
  end
end
