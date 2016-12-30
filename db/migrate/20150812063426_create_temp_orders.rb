class CreateTempOrders < ActiveRecord::Migration
  def change
    create_table :temp_orders do |t|
      t.integer :cart_id
      t.integer :quantity
      t.integer :activity_id
      t.timestamps
    end
  end
end
