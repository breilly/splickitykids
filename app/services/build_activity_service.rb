class BuildActivityService < ApplicationService

  attr_accessor :activity, :vendor

  # Initialze the service object
  def initialize(params)
    self.activity = Activity.new(params[:activity_params])
    self.vendor = params[:vendor]
    super
  end

  # Build the activity objecy and assign it to data result
  def perform
    call { result.data = build_activity }
  end

  # run the service and get the result
  def run_and_get_result
   perform
   result.data if result.success?
 end

  # Create stripe account if vendor doesnt have activity account yet
  # Make activity object belongs to vendor
  def build_activity
    create_stripe_account if vendor.account.blank?
    activity.vendor_id = vendor.id
    activity
  end

  # Create stripe account using the service object
  def create_stripe_account
     stripe_account_service = CreateStripeAccountService.new(
                                is_managed: false,
                                country_code: "US",
                                email: vendor.email
                              )
     stripe_account_service.perform
     if stripe_account_service.result.success?
       vendor.account = stripe_account_service.result.data.id
       vendor.save
     end
  end

end
