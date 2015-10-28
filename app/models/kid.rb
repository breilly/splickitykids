class Kid < ActiveRecord::Base
	belongs_to :user
	has_many :activities
	has_and_belongs_to_many :orders
	has_and_belongs_to_many :temp_orders
	#validates :first_name, :last_name, :dob

  if Rails.env.development?
    has_attached_file :image, :styles => { :medium => "250x250#", :thumb => "100x100>" }, :default_url => "happyface50.png",
      :storage => :s3,
      :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml",
  	  :url => ':s3_domain_url',
      #:s3_host_alias => 'd1j1smmjasrwse.cloudfront.net',
  	  :path => "images/:id/:style.:extension"
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  else
    has_attached_file :image, :styles => { :medium => "250x250#", :thumb => "100x100>" }, :default_url => "happyface50.png",
  	  #:download,
      :storage => :s3,
      :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml",
  	  :url => ':s3_alias_url',
      :s3_host_alias => 'd1j1smmjasrwse.cloudfront.net',
  	  :path => "images/:id/:style.:extension"
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  end
end
