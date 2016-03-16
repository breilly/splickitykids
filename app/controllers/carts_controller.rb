class CartsController < ApplicationController
  before_action :authenticate_user!
  require 'json'
    
  def index
    @carts = current_user.carts
  end
  
  def add_to_cart
    if current_user.kids.size == 0
      flash[:danger] = "Please add kid."  
      redirect_to new_kid_url
    end
    @activity = Activity.find(params[:activity_id])
    @carts = current_user.carts
  end
  
  def add
    kid_ids = params[:kid_ids]
    cart = Cart.where(:user_id=>current_user.id)
    activity = Activity.find(params[:activity_id])
    current_user.carts.where(activity_id: params[:activity_id]).delete_all
    if(!kid_ids.blank? && kid_ids.class == Array)
      kid_ids.each do |k|
        current_user.carts.create(activity_id: activity.id, kid_id: k, price: activity.price, repeats: activity.repeats, plan: activity.plan)
      end
      redirect_to carts_url
    elsif(!kid_ids.blank? && kid_ids.to_i > 0)
        current_user.carts.create(activity_id: activity.id, kid_id: kid_ids, price: activity.price, repeats: activity.repeats, plan: activity.plan)
        redirect_to place_order_carts_url(activity_id: activity.id)
    end
  end
  
  def destroy
    @cart = current_user.carts.find(params[:id]).delete
    redirect_to carts_url
  end
  
  def place_order
    if(params[:activity_id])
      @activity = Activity.find_by_id(params[:activity_id])
      @total_cart_amount = @activity.price
    else
      carts = current_user.carts.where(is_paid: false, repeats: "no")
      @total_cart_amount = carts.collect{|t| t.price}.sum
    end
  end
  
  def complete_order
    carts = current_user.carts
    @order = Order.new(:address=>params[:address], :state=>params[:state],:city=>params[:city])
    @order.buyer_id = current_user.id
    Stripe.api_key = ENV["STRIPE_API_KEY"]
    token = params[:stripeToken]
    #@user = current_user
    if params[:activity_id]
      activity = Activity.find_by_id(params[:activity_id])
    end
    if(activity.nil?)
      error1 = one_time_payment(token)
    elsif(activity && Activity::STRIPE_INTERVAL.include?(activity.repeats))
      error2 = subscriptions_payment(token, params[:activity_id])
    end
    
    if (!error1.blank? && error1.length > 0) || (!error2.blank? && error2.length > 0)
      flash[:danger] = error1 if !error1.blank? && error1.length > 0
      flash[:danger] = error2 if !error2.blank? && error2.length > 0
      redirect_to place_order_carts_url and return
    end

    respond_to do |format|
      if @order.save
        buyer = current_user
        carts.where(is_paid: true).each do |c|
          order_details = OrderDetail.create(order_id: @order.id, kid_id: c.kid_id, activity_id: c.activity_id, price: c.price, stripe_response: c.stripe_response, plan: c.plan, repeats: c.repeats, stripe_customer_token: c.stripe_customer_token)
          activity_seller = c.activity.user
          Payment.create!(order_id: @order.id, order_detail_id: order_details.id, kid_id: c.kid_id, amount_recieved: c.price, seller_id: activity_seller.id, buyer_id: current_user.id, activity_id: c.activity_id, splickitykids_amount: (c.price * 0.0).floor, seller_amount: (c.price * 1.0).floor, stripe_customer_token: c.stripe_customer_token, recurring_type: c.repeats, plan: c.plan)
          OrderMailer.send_order_email_to_seller(order_details, current_user, activity_seller).deliver
          c.delete
        end
        # Sends email to user when order is created.
        #OrderMailer.order_email(@order, @user).deliver
        OrderMailer.send_order_email_to_buyer(@order, buyer).deliver
        format.html { redirect_to root_url and return}
      else
        format.html { render :show }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
    
  end
  
  def one_time_payment(token)
    one_time_cart_amount = current_user.carts.where("is_paid = false and (repeats is null OR repeats = ?)", "no").collect{|t| t.price}.sum
    one_time_cart_amount = one_time_cart_amount * 100
    if one_time_cart_amount == 0
      current_user.carts.where("repeats is null OR repeats = ?", "no").update_all(is_paid: true)
      return
    end
    
    begin
      charge = Stripe::Charge.create(
        :amount => one_time_cart_amount,
        :currency => "usd",
        :card => token,
        :description => current_user.email
      )
      flash[:notice] = "Thanks for registering!"
      current_user.carts.where("repeats is null OR repeats = ?", "no").update_all(is_paid: true)
    rescue Stripe::CardError => e
      return e.message
    rescue Stripe::InvalidRequestError => e
      return "There was a problem connecting to stripe. Please try again! \n" + e.message  
    end
    return
  end
  
  def subscriptions_payment(token, activity_id)
    #carts = current_user.carts.where.not(repeats: nil).where.not(repeats: "no").where(is_paid: false) #.where.not(plan: nil)
    #return if carts.blank?
    
    #carts.each do |cart|
    cart = current_user.carts.where(activity_id: activity_id).first
    
    if cart.plan.nil?
      cart.update_attributes(is_paid: true)	
    else
      begin
        customer = Stripe::Customer.create(
          :source => token,
          :plan => cart.plan,
          :email => current_user.email
          )
        flash[:notice] = "Thanks for subscription!"
        cart.update(is_paid: true, stripe_customer_token: customer.id, stripe_response: customer)
      rescue Stripe::CardError => e
        return e.message
      rescue Stripe::InvalidRequestError => e
        error = "There was a problem connecting to stripe subscription. Please try again! <br>" + e.message 
        return error
      end
    end
    return
  end
  
  
end
