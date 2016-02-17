class AddKidIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :kid_id, :integer
    add_column :payments, :activity_id, :integer
    add_column :payments, :buyer_id, :integer
    add_column :payments, :recurring_type, :string
    add_column :payments, :plan, :integer
    
  end
end
