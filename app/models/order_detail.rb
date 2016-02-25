class OrderDetail < ActiveRecord::Base
  serialize :stripe_response, JSON
  
  belongs_to :activity
  belongs_to :kid  
  
end
