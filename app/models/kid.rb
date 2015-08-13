class Kid < ActiveRecord::Base
	belongs_to :user
	has_many :activities
	has_and_belongs_to_many :orders
	has_and_belongs_to_many :temp_orders
	#validates :first_name, :last_name, :dob
end
