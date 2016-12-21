class Vendors::OmniauthCallbacksController < ApplicationController

  def stripe_connect
    @vendor = current_vendor
    begin
      if @vendor
        update_stripe_attributes
        redirect_to edit_vendor_registration_path, notice: 'Your stripe account has successfully connected'
      elsif (email = request.env["omniauth.auth"].info.email) && (@vendor = Vendor.where(email: email).first)
        update_stripe_attributes
        sign_in_and_redirect @vendor, :event => :authentication
      else
        redirect_to new_vendor_registration_url, alert: 'Your stripe account has not registered in our system, please signup for free'
      end
    rescue => e
       Rails.logger.info "Error when connecting Stripe: #{e.inspect}"
       redirect_to root_path, alert: 'Stripe connect failed, please try again later or contact our support team'
    end
  end

  private

  def update_stripe_attributes
    @vendor.update_attributes({
       stripe_provider: request.env["omniauth.auth"].provider,
       stripe_account_id: request.env["omniauth.auth"].uid,
       stripe_token: request.env["omniauth.auth"].credentials.token,
       stripe_publishable_key: request.env["omniauth.auth"].info.stripe_publishable_key,
       stripe_refresh_token: request.env["omniauth.auth"].credentials.refresh_token,
       stripe_business_name: request.env["omniauth.auth"].extra.extra_info.business_name,
       stripe_account_name: request.env["omniauth.auth"].info.name
    })
  end

 end
