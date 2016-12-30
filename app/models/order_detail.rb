class OrderDetail < ActiveRecord::Base
  serialize :stripe_response, JSON
  
  belongs_to :activity
  belongs_to :kid
  belongs_to :order
  
end
