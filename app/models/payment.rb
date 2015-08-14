class Payment < ActiveRecord::Base
  belongs_to :seller, class_name: "User"
  belongs_to :order
  belongs_to :temp_order
end
