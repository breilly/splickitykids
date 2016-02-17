class AddPlanIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :plan_id, :integer
  end
end
