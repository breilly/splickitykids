class RemoveTempOrderIdToActivities < ActiveRecord::Migration
  def change
    remove_column :activities, :temp_order_id, :integer
    add_column :carts, :repeats, :string
    add_column :carts, :plan, :string
    change_column :activities, :plan, :string
  end
end
