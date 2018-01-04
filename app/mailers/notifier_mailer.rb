class NotifierMailer < ApplicationMailer
  default from: 'admin@bookstore.com'

  def user_email(user)
    @user = user
    mail(to: @user.email, subject: default_i18n_subject(email: @user.email))
  end

  def order_email(order)
    @user = order.user
    @order = order.decorate
    @order_items = @order.order_items
    mail(to: @user.email, subject: default_i18n_subject(number: @order.number))
  end
end
