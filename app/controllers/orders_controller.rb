class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_vendor!, only: [:sales]
  before_action :authenticate_user!, except: [:sales]
  
  respond_to :html

  def sales
    @order_details = OrderDetail.where(activity_id: current_vendor.activities_ids)
  end

  def purchases
   #p @orders = current_user.orders.joins(order_details: [:kid,activity: :user])
   @order_details = OrderDetail.joins(:order).where(order: {buyer_id: current_user})
   #.select("orders.id,order_details.activity_id,order_details.kid_id,order_details.created_at,order_details.price")
  end

  def unsubscribe
    order = current_user.orders.where(id: params[:id]).first
    order_detail = order.order_details.first
    stripe_customer_token = order_detail.stripe_customer_token
    customer = Stripe::Customer.retrieve(stripe_customer_token)
    customer.cancel_subscription()
    order_detail.update_attributes(payment_status: false)
    flash[:notice] = "Activity " + order_detail.activity.name + " has been unsubscribed."
    redirect_to purchases_path
  end

  def new
    @order = Order.new
    @activity = Activity.find(params[:activity_id])
    @kids = current_user.kids
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
        :amount => (@activity.price * params[:kid_ids].count).floor,
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
