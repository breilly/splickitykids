class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
         
  validates :first_name, :last_name, presence: true
  
  has_many :activities, dependent: :destroy
  has_many :sales, class_name: "Order", foreign_key: "seller_id"
  has_many :purchases, class_name: "Order", foreign_key: "buyer_id"
  has_many :kids
  has_one :cart
  
  ROLES = %w[registered vendor]
  
  before_create do
    self.account_active = true if role != "vendor"
  end
  
  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def full_name
    name = []
    name << self.first_name.capitalize unless self.first_name.blank?
    name << self.last_name.capitalize unless self.last_name.blank?
    name.join(" ")
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
  
end
