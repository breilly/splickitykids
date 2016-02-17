class DropKidTempOrders < ActiveRecord::Migration
  def change
    drop_table :kid_temp_orders
  end
end
