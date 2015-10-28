# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
	def order_mail_preview
		OrderMailer.order_email(User.first)
	end
end
