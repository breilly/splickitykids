class DropTempOrders < ActiveRecord::Migration
  def change
   drop_table :temp_orders
  end
end
