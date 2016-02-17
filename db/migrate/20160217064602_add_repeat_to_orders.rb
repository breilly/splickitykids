class AddRepeatToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :repeat, :string
  end
end
