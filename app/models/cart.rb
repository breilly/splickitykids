class Cart < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity
  belongs_to :kid
  
  serialize :stripe_response
end
