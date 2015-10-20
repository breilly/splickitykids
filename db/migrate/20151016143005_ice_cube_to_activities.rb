class IceCubeToActivities < ActiveRecord::Migration
  def change
  	add_column :activities, :is_all_day, :boolean
  	add_column :activities, :from_date, :date
  	add_column :activities, :from_time, :time
  	add_column :activities, :to_date, :date
  	add_column :activities, :to_time, :time
  	add_column :activities, :repeats, :string
  	add_column :activities, :repeats_every_n_days, :integer
  	add_column :activities, :repeats_every_n_weeks, :integer
  	add_column :activities, :repeats_weekly_each_days_of_the_week_mask, :integer
  	add_column :activities, :repeats_every_n_months, :integer
  	add_column :activities, :repeats_monthly, :string
  	add_column :activities, :repeats_monthly_on_ordinals_mask, :integer
  	add_column :activities, :repeats_monthly_on_days_of_the_week_mask, :integer
 	add_column :activities, :repeats_every_n_years, :integer
 	add_column :activities, :repeats_yearly_each_months_of_the_year_mask, :integer
 	add_column :activities, :repeats_yearly_on, :boolean
 	add_column :activities, :repeats_yearly_on_ordinals_mask, :integer
 	add_column :activities, :repeats_yearly_on_days_of_the_week_mask, :integer
 	add_column :activities, :repeat_ends, :string
 	add_column :activities, :repeat_ends_on, :date
 	add_column :activities, :time_zone, :string
  end
end
