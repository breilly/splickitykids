class AddAmPmToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :start_am_pm, :string
  	add_column :activities, :end_am_pm, :string
  end
end
