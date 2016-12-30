class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount_recieved 
      t.integer :seller_id
      t.integer :splickitykids_amount
      t.integer :seller_amount
      t.integer :order_id
      t.integer :temp_order_id
      t.timestamps
    end
  end
end
