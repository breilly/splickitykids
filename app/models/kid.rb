class Kid < ActiveRecord::Base
	belongs_to :user
	has_many :activities
	has_and_belongs_to_many :orders
	#validates :first_name, :last_name, :dob
end
