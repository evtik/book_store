class NotifierMailerPreview < ActionMailer::Preview
  def order_email
    NotifierMailer.order_email(Order.last)
  end
end
