class CartsController < ApplicationController
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
    total_amount = activity.price.to_i * params[:quantity].to_i
    temp_order = TempOrder.create!(:cart_id=>cart.id, :activity_id=> params[:activity_id], :quantity=>params[:quantity], :amount=>activity.price.to_i, :total_amount=>total_amount, :kid_ids=>[])
    if params[:kid_ids]
      params[:kid_ids].each do |k|
        KidTempOrder.create!(:kid_id => k.to_i, :temp_order_id=>temp_order.id)
      end
    end
    redirect_to cart_path(cart)
  end
  
  def show
    @cart = Cart.where(:user_id=>current_user.id).first
  end
  
  def destroy
    @cart = Cart.find(params[:id])
    if @cart.temp_orders.find(params[:temp_order_id]).destroy
      KidTempOrder.where(:temp_order_id=>params[:temp_order_id]).each do |k|
        k.destroy
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
    
    begin
      charge = Stripe::Charge.create(
        :amount => (params[:total_cart_amount].to_i * 100).floor,
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
        @cart.temp_orders.each do |t|
          t.update_attribute(:order_id, @order.id)
        end
        @cart.destroy
        format.html { redirect_to root_url }
      else
        format.html { render :show }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
    
  end
  
end
