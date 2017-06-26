class NotifierMailer < ApplicationMailer
  default from: 'admin@bookstore.com'

  def user_email(user)
    @user = user
    mail(to: @user.email,
         subject: "Created account for #{@user.email}")
  end

  def order_email(order)
    @user = order.user
    @order = order.decorate
    @order_items = @order.order_items
    @url = 'http://some.where'
    mail(to: @user.email,
         subject: "Order #{@order.number} has been successfully placed!")
  end
end
