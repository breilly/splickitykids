require 'elasticsearch/model'

class Activity < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include IceCubeMethods

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
  
  validates :name, :description, :price, #:starts_at, :ends_at, #:start_date, #:start_hour, :start_min, :start_am_pm, :end_date, :end_hour, :end_min, 
    #:end_am_pm, 
    :spots, :address, :city, :state, :zip_code, :category, :time_zone, :from_date, :to_date, :from_time, :to_time, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates_attachment_presence :image
  validates_attachment :image,
  :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] }
  
  belongs_to :user
  has_many :orders
  has_many :kids
  has_many :temp_orders

  def start_time
    start_hour + ":" + start_min + " " + start_am_pm
  end

  def end_time
    end_hour + ":" + end_min + " " + end_am_pm
  end

end

