class Activity < ActiveRecord::Base
  if Rails.env.development?
    has_attached_file :image, :styles => { :medium => "250x250#", :thumb => "100x100>" }, :default_url => "batman.png",
      :storage => :s3,
      :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml",
  	  :url => ':s3_domain_url',
      #:s3_host_alias => 'd1j1smmjasrwse.cloudfront.net',
  	  :path => "images/:id/:style.:extension"
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  else
    has_attached_file :image, :styles => { :medium => "250x250#", :thumb => "100x100>" }, :default_url => "batman.png",
  	  #:download,
      :storage => :s3,
      :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml",
  	  :url => ':s3_alias_url',
      :s3_host_alias => 'd1j1smmjasrwse.cloudfront.net',
  	  :path => "images/:id/:style.:extension"
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  end
  
  validates :name, :description, :price, :start_date, :end_date, :spots, :address, :city, :state, :zip_code, :category, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates_attachment_presence :image
  validates_attachment :image,
  :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] }
  
  belongs_to :user
  has_many :orders
end
