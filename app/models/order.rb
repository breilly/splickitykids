class Order < ActiveRecord::Base
  validates :address, :city, :state, presence: true
  
  belongs_to :activity
  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"
  has_many :temp_orders
  has_and_belongs_to_many :kids, join_table: :kid_orders
end
