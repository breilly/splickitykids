class CreateKidTempOrders < ActiveRecord::Migration
  def change
    create_table :kid_temp_orders do |t|
      t.integer :kid_id
      t.integer :temp_order_id
    end
  end
end
