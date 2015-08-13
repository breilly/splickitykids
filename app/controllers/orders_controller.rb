class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html

  def sales
    @orders = Order.all.where(seller: current_user).order("created_at DESC")
  end

  def purchases
    @orders = Order.all.where(buyer: current_user).order("created_at DESC")
  end

  def new
    @order = Order.new
    @activity = Activity.find(params[:activity_id])
    @kids = Kid.all
    respond_with(@order)
  end

  def create
    @order = Order.new(order_params)
    @activity = Activity.find(params[:activity_id])
    @seller = @activity.user
    @kid = Kid.all
    #@kids = Kid.all
    
    @order.activity_id = @activity.id
    @order.buyer_id = current_user.id
    @order.seller_id = @seller.id
        
    Stripe.api_key = ENV["STRIPE_API_KEY"]
    token = params[:stripeToken]
    
    puts token
    
    begin
      charge = Stripe::Charge.create(
        :amount => (@activity.price * 100).floor,
        :currency => "usd",
        :card => token,
        :description => current_user.email
        )
      flash[:notice] = "Thanks for registering!"
    rescue Stripe::CardError => e
      flash[:danger] = e.message
    end
    
    respond_to do |format|
      if @order.save
        if params[:kid_ids]
          params[:kid_ids].each do |k|
            KidOrder.create!(:kid_id => k.to_i, :order_id=>@order.id)
          end  
        end
        format.html { redirect_to root_url }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:address, :city, :state, :kid_ids)
    end
end
