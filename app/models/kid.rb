class Kid < ActiveRecord::Base
	belongs_to :user
	has_many :activities
	has_and_belongs_to_many :orders
	has_and_belongs_to_many :temp_orders
	#validates :first_name, :last_name, :dob

  has_attached_file :image, :styles => { :medium => "250x250#", :thumb => "100x100>" }, :default_url => "happyface50.png"

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def name
    name = []
    name << self.first_name.capitalize unless self.first_name.blank?
    name << self.last_name.capitalize unless self.last_name.blank?
    name.join(" ")
  end

end
