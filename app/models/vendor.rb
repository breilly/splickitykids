class Vendor < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :first_name, :last_name, :ein, presence: true

  has_many :activities, dependent: :destroy
  has_many :orders, class_name: "Order", foreign_key: "buyer_id"

  before_create do
    self.account_active = true
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
