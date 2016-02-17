class AddPlanToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :plan, :integer
  end
end
