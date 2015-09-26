class AddScheduleOptionsToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :schedule_options, :string
  end
end
