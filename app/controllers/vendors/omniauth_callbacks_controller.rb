class Vendors::OmniauthCallbacksController < ApplicationController

  def stripe_connect
    if current_vendor.update_attributes({
       stripe_provider: request.env["omniauth.auth"].provider,
       stripe_account_id: request.env["omniauth.auth"].uid,
       stripe_token: request.env["omniauth.auth"].credentials.token,
       stripe_publishable_key: request.env["omniauth.auth"].info.stripe_publishable_key,
       stripe_refresh_token: request.env["omniauth.auth"].credentials.refresh_token,
       stripe_business_name: request.env["omniauth.auth"].extra.extra_info.business_name,
       stripe_account_name: request.env["omniauth.auth"].info.name
       })
      redirect_to edit_vendor_registration_path, notice: 'Your stripe account has successfully connected'
    else
      redirect_to edit_vendor_registration_path, alert: 'Stripe connect failed, please try again later or contact our support team'
    end
  end

 end
