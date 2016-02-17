class RemoveTempOrderIdFromPayments < ActiveRecord::Migration
  def change
    remove_column :payments, :temp_order_id, :integer
  end
end
