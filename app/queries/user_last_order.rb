class UserLastOrder < Rectify::Query
  def initialize(user_id)
    @user_id = user_id
  end

  def query
    Order.where(user_id: @user_id).order('orders.created_at DESC')
         .includes(:billing_addresses, :credit_card, :shipment, :coupon,
                   order_items: [:book])
  end
end
