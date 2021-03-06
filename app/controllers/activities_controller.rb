class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_vendor!, only: [#:seller,
    :new, :create, :edit, :update, :destroy]
  before_filter :check_vendor, only: [:edit, :update, :destroy]

  def seller
    @activities = Activity.where(vendor: current_vendor).order("created_at DESC")
  end

  # GET /activities
  # GET /activities.json
  def index
    @home_page = true
    @activities = Activity.all.order("created_at DESC")
    if params[:q].present?
        @search = Activity.search(params[:q].split.join(' AND ')).records
    else
      @search = []
    end
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
   # @kids = current_user.kids
    #respond_with(@kids)
    if params[:q].present?
        @search = Activity.search(params[:q].split.join(' AND '))
    else
      @search = []
    end
  end

  # GET /activities/new
  def new
    @activity = Activity.new
    if current_vendor.stripe_account_id.blank?
      redirect_to edit_vendor_registration_path, alert: 'Please connect your stripe account before create new activity'
    else
      new_activity_path
    end

  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities
  # POST /activities.json
  def create
    activity_service = BuildActivityService.new(activity_params: activity_params,
                                                vendor: current_vendor)
    @activity = activity_service.run_and_get_result

    respond_to do |format|
      if @activity.save
        create_stripe_plan if @activity.price > 0
        format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @activity.delete
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create_stripe_plan
    if @activity.valid? && @activity.repeats != "no" && @activity.repeats != ''
      Stripe.api_key = ENV["STRIPE_API_KEY"]
      plan = @activity.name.gsub(" ","-") + "-" + current_user.id.to_s + "-" + @activity.id.to_s
      interval = Activity::STRIPE_INTERVAL[@activity.repeats]
      subscription = Stripe::Plan.create(
        :amount => (@activity.price.to_i)*100,
        :interval => interval,
        :name => @activity.name,
        :currency => 'usd',
        :id => plan # This ensures that the plan is unique in stripe
      )
      @activity.update_attribute(:plan,plan)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:name, :description, :price, :schedule_options, :from_date, :from_time,
        :to_date, :to_time, :is_all_day, :repeat_ends, :repeat_ends_on, :repeats, :repeats_every_n_days, :repeats_every_n_weeks,
        :repeats_every_n_months, :repeats_monthly, :repeats_monthly_on_ordinals, :repeats_every_n_years, :repeats_yearly_on,
        :time_zone, :spots, :address, :city, :state, :zip_code, :category, :image,
        :repeats_weekly_each_days_of_the_week => [],
        :repeats_monthly_each_days_of_the_month => [],
        :repeats_monthly_on_days_of_the_week => [],
        :repeats_yearly_each_months_of_the_year => [],
        :repeats_yearly_on_days_of_the_week => [],
        :repeats_yearly_on_ordinals => []
        #:starts_at, :ends_at, #:start_date, :start_hour, :start_min, :start_am_pm,
        #:end_date, :end_hour, :end_min, :end_am_pm,
        )
    end

    def check_vendor
      if current_vendor != @activity.vendor
        redirect_to root_url, alert: "Sorry, this activity belongs to someone else"
      end
    end
end
