class KidTempOrder < ActiveRecord::Base
  belongs_to :kid
  belongs_to :temp_order
end
