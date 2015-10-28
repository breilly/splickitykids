class CartsController < ApplicationController
  before_action :authenticate_user!
  
  def add_to_cart
    @activity = Activity.find(params[:activity_id])
    @temp_order = TempOrder.new
  end
  
  def add
    cart = Cart.where(:user_id=>current_user.id).first
    if cart.nil?
      cart = Cart.create!(:user_id=>current_user.id)
    end
    activity = Activity.find(params[:activity_id].to_i)
    total_amount = activity.price.to_i * params[:kid_ids].count
    temp_order = TempOrder.create!(:seller_id=>activity.user.id, :cart_id=>cart.id, :activity_id=> params[:activity_id], :quantity=>params[:kid_ids].count, :amount=>activity.price.to_i, :total_amount=>total_amount, :kid_ids=>[])
    if params[:kid_ids]
      params[:kid_ids].each do |k|
        KidTempOrder.create!(:kid_id => k.to_i, :temp_order_id=>temp_order.id)
      end
    end
    redirect_to cart_path(cart)
  end
  
  def edit
    @temp_order = TempOrder.find(params[:temp_order_id])
    @activity = @temp_order.activity
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
    @cart = Cart.find(params[:id])
    if @cart.temp_orders.find(params[:temp_order_id]).delete
      KidTempOrder.where(:temp_order_id=>params[:temp_order_id]).each do |k|
        k.delete
      end
    end
    redirect_to cart_path(@cart) 
  end
  
  def place_order
    cart = Cart.find(params[:cart_id])
    @total_cart_amount = cart.temp_orders.collect{|t| t.total_amount}.reject(&:blank?).sum
  end
  
  def complete_order
    @cart = Cart.find(params[:cart_id])
    @order = Order.new(:address=>params[:address], :state=>params[:state],:city=>params[:city])
    @order.buyer_id = current_user.id
    Stripe.api_key = ENV["STRIPE_API_KEY"]
    token = params[:stripeToken]
    #@user = current_user
    
    begin
      charge = Stripe::Charge.create(
        :amount => (params[:total_cart_amount].to_i).floor,
        :currency => "usd",
        :card => token,
        :description => current_user.email
        )
      flash[:notice] = "Thanks for registering!"
    rescue Stripe::CardError => e
      flash[:danger] = e.message
    rescue Stripe::InvalidRequestError => e
      flash[:danger] = "There was a problem connecting to stripe. Please try again!"  
      redirect_to place_order_carts_path(:cart_id=>@cart.id) and return
    end
    respond_to do |format|
      if @order.save

        # Sends email to user when order is created.
        #OrderMailer.order_email(@order, @user).deliver
        
        @cart.temp_orders.each do |t|
          t.update_attribute(:order_id, @order.id)
          Payment.create!(:temp_order_id=>t.id, :amount_recieved=>(t.activity.price).floor, :seller_id=>t.activity.user.id, :splickitykids_amount=>(t.activity.price * 0.1).floor, :seller_amount => (t.activity.price * 0.9).floor)
        end
        @cart.delete
        format.html { redirect_to root_url }
      else
        format.html { render :show }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
    
  end
  
end
