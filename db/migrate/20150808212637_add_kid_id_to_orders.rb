class AddKidIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :kid_id, :integer
  end
end
