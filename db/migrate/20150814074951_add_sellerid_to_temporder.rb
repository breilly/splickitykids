class AddSelleridToTemporder < ActiveRecord::Migration
  def change
    add_column :temp_orders, :seller_id, :integer
  end
end
