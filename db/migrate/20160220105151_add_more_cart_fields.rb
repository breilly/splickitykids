class AddMoreCartFields < ActiveRecord::Migration
  def change
    add_column :carts, :is_paid, :boolean, :default => false
    add_column :carts, :stripe_response, :text
    add_column :carts, :stripe_customer_token, :string
    add_column :order_details, :stripe_response, :text
    add_column :order_details, :plan, :string
    add_column :order_details, :repeats, :string
    remove_column :orders, :activity_id
    remove_column :orders, :kid_id
    remove_column :orders, :seller_id
    add_column :order_details, :stripe_customer_token, :string
  end
end
