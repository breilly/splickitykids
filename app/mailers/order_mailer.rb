class OrderMailer < ActionMailer::Base
  default from: "blair@splickitykids.com"

  #def order_email(user)	
  	#@user = user
  	#@order = order
  	#@orders = Order.all.where(buyer: @user_id).where.not(activity: nil).order("created_at DESC")

  	#mail(to: @user.email, subject: 'splickitykids | Registration Confirmation')
  #end
  
  def send_order_email_to_buyer(order, buyer)
    @buyer = buyer
    @order = order
    mail(to: @buyer.email, subject: "Your order has been placed!")
  end
  
  def send_order_email_to_seller(order_detail, buyer, seller)
    @buyer = buyer
    @seller = seller
    @order_detail = order_detail
    mail(to: @seller.email, subject: "Order placed by Customer!")
  end
  
end
