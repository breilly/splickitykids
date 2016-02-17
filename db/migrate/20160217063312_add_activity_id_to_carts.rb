class AddActivityIdToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :activity_id, :integer
  end
end
