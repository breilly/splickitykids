class CreateOrderDetails < ActiveRecord::Migration
  def change
    create_table :order_details do |t|
      t.integer :order_id
      t.integer :kid_id
      t.integer :activity_id
      t.integer :price

      t.timestamps
    end
  end
end
