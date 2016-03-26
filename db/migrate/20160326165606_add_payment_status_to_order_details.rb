class AddPaymentStatusToOrderDetails < ActiveRecord::Migration
  def change
    add_column :order_details, :payment_status, :boolean, default: false
  end
end
