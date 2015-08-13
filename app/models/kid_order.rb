class KidOrder < ActiveRecord::Base
  belongs_to :kid
  belongs_to :order
end
