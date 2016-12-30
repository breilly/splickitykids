class IceCubeAdditionToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :repeats_monthly_each_days_of_the_month_mask, :integer 
  end
end
