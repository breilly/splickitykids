class CreateKidOrders < ActiveRecord::Migration
  def change
    create_table :kid_orders do |t|
      t.integer :kid_id
      t.integer :order_id
    end
  end
end
