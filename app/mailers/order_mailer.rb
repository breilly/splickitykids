class OrderMailer < ActionMailer::Base
  default from: "blair@splickitykids.com"

  #def order_email(user)	
  	#@user = user
  	#@order = order
  	#@orders = Order.all.where(buyer: @user_id).where.not(activity: nil).order("created_at DESC")

  	#mail(to: @user.email, subject: 'splickitykids | Registration Confirmation')
  #end
end
