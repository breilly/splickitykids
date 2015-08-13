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
    temp_order = TempOrder.create!(:cart_id=>cart.id, :activity_id=> params[:activity_id], :quantity=>params[:quantity], :kid_ids=>[])
    params[:kid_ids].each do |k|
      KidTempOrder.create!(:kid_id => k.to_i, :temp_order_id=>temp_order.id)
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
  
end
