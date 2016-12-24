class Vendor < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :async, :validatable, :confirmable

  validates :first_name, :last_name, :company_name, :email, :website, presence: true

  if Rails.env.development?
    has_attached_file :verification_file, :styles => { :medium => "250x250#", :thumb => "100x100>" }, #:default_url => "batman.png",
      :storage => :s3,
      :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml",
      :url => ':s3_domain_url',
      #:s3_host_alias => 'd1j1smmjasrwse.cloudfront.net',
      :path => "images/:id/:style.:extension"
    validates_attachment_content_type :verification_file, :content_type => /\Aimage\/.*\Z/
  else
    has_attached_file :verification_file, :styles => { :medium => "250x250#", :thumb => "100x100>" }, #:default_url => "batman.png",
      #:download,
      :storage => :s3,
      :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml",
      :url => ':s3_alias_url',
      :s3_host_alias => 'd1j1smmjasrwse.cloudfront.net',
      :path => "images/:id/:style.:extension",
      :s3_protocol => :https
    validates_attachment_content_type :verification_file, :content_type => /\Aimage\/.*\Z/
  end

  #validates_attachment_presence :verification_file
  validates_attachment :verification_file,
  :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] }

  has_many :activities, dependent: :destroy
  has_many :orders, class_name: "Order", foreign_key: "buyer_id"

  before_create do
    self.account_active = true
  end

  def activities_ids
    activities.pluck(:id)
  end

  def self.search(search)
    if search
      self.where("LOWER(CONCAT(first_name,' ', last_name)) LIKE ?", "%#{search.downcase}%")
    else
      self.all
    end
  end

  def active_for_authentication?
    # Uncomment the below debug statement to view the properties of the returned self model values.
    # logger.debug self.to_yaml

    super && account_active?
  end

  def full_name
    name = []
    name << self.first_name.capitalize unless self.first_name.blank?
    name << self.last_name.capitalize unless self.last_name.blank?
    name.join(" ")
  end

end
