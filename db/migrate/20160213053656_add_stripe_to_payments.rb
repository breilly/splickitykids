class AddStripeToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :stripe_user_token, :string
  end
end
