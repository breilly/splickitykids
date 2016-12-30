class AddTempOrderIdToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :temp_order_id, :integer
  end
end
