class TempOrder < ActiveRecord::Base
  belongs_to :cart
  belongs_to :activity
  belongs_to :order
  belongs_to :seller, class_name: "User"
  has_and_belongs_to_many :kids, join_table: :kid_temp_orders, dependent: :destroy 
end
