class UserMailer < ApplicationMailer
  def send_update_user_mail(user)
    @user = user
    mail(to: @user.email, subject: "Your Profile has been updated")
  end
end
