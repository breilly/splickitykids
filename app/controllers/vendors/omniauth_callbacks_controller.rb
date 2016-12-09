class Vendors::OmniauthCallbacksController < ApplicationController

  def stripe_connect
    if current_vendor.update_attributes({
       provider: request.env["omniauth.auth"].provider,
       uid: request.env["omniauth.auth"].uid,
       access_code: request.env["omniauth.auth"].credentials.token,
       publishable_key: request.env["omniauth.auth"].info.stripe_publishable_key
       })
      redirect_to edit_vendor_registration_path, notice: 'Your stripe account has successfully connected'
    else
      redirect_to edit_vendor_registration_path, alert: 'Stripe connect failed, please try again later or contact our support team'
    end
  end

 end
