class CartsController < ApplicationController
  before_action :authenticate_user!
  require 'json'
    
  def index
    @carts = current_user.carts
  end
  
  def add_to_cart
    @activity = Activity.find(params[:activity_id])
    @carts = current_user.carts
  end
  
  def add
    cart = Cart.where(:user_id=>current_user.id)
    activity = Activity.find(params[:activity_id])
    current_user.carts.where(activity_id: params[:activity_id]).delete_all
    if params[:kid_ids]
      params[:kid_ids].each do |k|
        current_user.carts.create(activity_id: activity.id, kid_id: k, price: activity.price, repeats: activity.repeats, plan: activity.plan)
      end
    end
    redirect_to carts_url
  end
  
  def edit
    #@temp_order = TempOrder.find(params[:temp_order_id])
    #@activity = @temp_order.activity
  end
  
  def update
    cart = Cart.find(params[:id])
    # remove all existing kids
    KidTempOrder.where(:temp_order_id=>params[:temp_order_id].to_i).each do |t|
      t.delete
    end
    # add only selected kids
    if params[:kid_ids]
      params[:kid_ids].each do |k|
        KidTempOrder.create!(:kid_id => k.to_i, :temp_order_id=>params[:temp_order_id].to_i)
      end
    end  
    redirect_to cart_path(cart) 
  end
  
  def show
    @cart = Cart.where(:user_id=>current_user.id).first
  end
  
  def destroy
    @cart = current_user.carts.find(params[:id]).delete
    redirect_to carts_url
  end
  
  def place_order
    carts = current_user.carts.where(is_paid: false)
    @total_cart_amount = carts.collect{|t| t.price}.sum
  end
  
  def complete_order
    carts = current_user.carts
    @order = Order.new(:address=>params[:address], :state=>params[:state],:city=>params[:city])
    @order.buyer_id = current_user.id
    Stripe.api_key = ENV["STRIPE_API_KEY"]
    token = params[:stripeToken]
    #@user = current_user
    
    error1 = one_time_payment(token)
    error2 = subscriptions_payment(token)
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
    return if one_time_cart_amount <= 0
    
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
  
  def subscriptions_payment(token)
    carts = current_user.carts.where.not(repeats: nil).where.not(repeats: "no").where.not(plan: nil).where(is_paid: false)
    return if carts.blank?
    
    carts.each do |cart|
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
