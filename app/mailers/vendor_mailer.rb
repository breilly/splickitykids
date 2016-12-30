class VendorMailer < ApplicationMailer
  
  def send_update_vendor_mail(vendor)
    @vendor = vendor
    mail(to: @vendor.email, subject: "Your Profile has been updated!")
  end
  
  def send_activation_vendor_mail(vendor)
    @vendor = vendor
    mail(to: @vendor.email, subject: "Your Profile has been activated!")
  end

end