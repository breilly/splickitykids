class Cart < ActiveRecord::Base
  has_many :temp_orders
  belongs_to :user
end
