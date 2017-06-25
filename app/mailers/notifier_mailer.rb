class NotifierMailer < ApplicationMailer
  default from: 'admin@bookstore.com'

  def order_email(order)
    @user = order.user
    @order = order.decorate
    @order_items = @order.order_items
    @url = 'http://some.where'
    mail(to: @user.email,
         subject: "Order #{@order.number} has been successfully placed!")
  end
end
