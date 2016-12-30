class AddAmountToTempOrder < ActiveRecord::Migration
  def change
    add_column :temp_orders, :amount, :integer
    add_column :temp_orders, :total_amount, :integer
    add_column :temp_orders, :order_id, :integer
  end
end
