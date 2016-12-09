class CreateStripeAccountService < ApplicationService
  attr_accessor :is_managed, :country_code, :email

  # Initialze the service object
  def initialize(params)
    self.is_managed = params[:is_managed]
    self.country_code = params[:country_code]
    self.email = params[:email]
    super
  end

  # Create the script account and assign it to data result
  def perform
    call { result.data = create_stripe_account }
  end

  # Create stripe account managed / standalone base on is_managed value
  def create_stripe_account
    if is_managed
      create_stripe_managed_account
    else
      create_stripe_standalone_account
    end
  end

  # Create stripe standalone account
  # https://stripe.com/docs/connect/standalone-accounts
  def create_stripe_standalone_account
    Stripe::Account.create(
      :managed => false,
      :country => country_code,
      :email => email
    )
  end

  # Create stripe managed account
  # https://stripe.com/docs/connect/managed-accounts
  def create_stripe_managed_account
    raise "Managed account is disabled for now"
    Stripe::Account.create(
      :managed => true,
       :country => 'US',
       :email => current_vendor.email,
       :business_name => current_vendor.company_name,
       :external_account => {
         :object => "bank_account",
         :country => "US",
         :account_number => current_vendor.account_number,
         :account_holder_name => current_vendor.full_name,
         :currency => "usd",
         :routing_number => current_vendor.routing_number,
         :status => "new",
         :first_name => current_vendor.first_name,
         :last_name => current_vendor.last_name,
         :type => 'company'
       },
       :legal_entity => {
         :dob => {
           :day => current_vendor.dob_day,
           :month => current_vendor.dob_month,
           :year => current_vendor.dob_year
         },
         :business_name => current_vendor.company_name,
         :business_tax_id => current_vendor.ein,
         :first_name => current_vendor.first_name,
         :last_name => current_vendor.last_name,
         :type => 'company',
         :personal_id_number => current_vendor.ssn,
         #:ssn_last_4 => '4444',
         :address => {
           :city => 'Denver',
           :line1 => '123 Testing Lane',
           :postal_code => '80241',
           :state => 'CO'
         }#,
         #:verification => {
           #:purpose => 'identity_document',
           #:document => current_vendor.verification_file
       #}
       },
       :tos_acceptance => {
         :date => Time.now.to_i,
         :ip => request.remote_ip # Assumes you're not using a proxy
       },
     )

     #if current_vendor.account?
     #  Stripe.api_key = ENV["STRIPE_API_KEY"]
     #  token = params[:stripeToken]

     #  file_obj = Stripe::FileUpload.create(
     #    :stripe_account => current_vendor.account,
     #    :purpose => 'identity_document',
     #    :file => current_vendor.verification_file
     #  )
     #end

  end

end
