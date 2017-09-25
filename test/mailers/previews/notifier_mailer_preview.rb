class NotifierMailerPreview < ActionMailer::Preview
  def user_email
    NotifierMailer.user_email(User.last)
  end

  def order_email
    NotifierMailer.order_email(Order.last)
  end
end
