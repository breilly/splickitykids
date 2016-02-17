class AddKidIdToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :kid_id, :integer
  end
end
