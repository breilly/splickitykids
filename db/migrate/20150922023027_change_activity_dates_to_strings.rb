class ChangeActivityDatesToStrings < ActiveRecord::Migration
  def change
  	change_column :activities, :start_date, :string
  	change_column :activities, :end_date, :string
  end
end
