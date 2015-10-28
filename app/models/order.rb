class Order < ActiveRecord::Base
  validates :address, :city, :state, presence: true
  
  belongs_to :activity
  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"
  has_many :temp_orders
  has_and_belongs_to_many :kids, join_table: :kid_orders

  #def self.notify(order)
  #  activity = order.activity
  #  users = User.joins('left join order on order.user_id=users.id').where("activity_id=? and users.id!=?",activity.id,order.user_id).select("distinct users.id,users.first_name,users.email")
  #  users.each do |user|
  #    order.send_notification_email(user,order) if MailerSetting.check_mail_setting(user, 'activity_order_notification')
  #  end
  #end

  #def send_notification_email(user,order)
  #  OrderMailer.activity_order_notification(user,order).deliver
  #end
end
