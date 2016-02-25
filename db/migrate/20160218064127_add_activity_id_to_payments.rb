class AddActivityIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :kid_id, :integer
    add_column :payments, :activity_id, :integer
    add_column :payments, :buyer_id, :integer
    add_column :payments, :recurring_type, :string
    add_column :payments, :plan, :integer
    add_column :payments, :stripe_user_token, :string
    remove_column :payments, :temp_order_id, :integer
    add_column :activities, :plan, :integer
    add_column :carts, :activity_id, :integer
    add_column :carts, :kid_id, :integer
    add_column :carts, :price, :integer
  end
end
