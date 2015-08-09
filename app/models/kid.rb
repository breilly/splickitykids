class Kid < ActiveRecord::Base
	belongs_to :user
	has_many :activities
	has_many :orders
	#validates :first_name, :last_name, :dob
end
