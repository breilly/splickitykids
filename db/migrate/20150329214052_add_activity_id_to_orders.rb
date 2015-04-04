class AddActivityIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :activity_id, :integer
  end
end
