class AddCategoryToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :category, :string
  end
end
