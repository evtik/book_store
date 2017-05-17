class UserLastOrder < Rectify::Query
  def initialize(user_id)
    @user_id = user_id
  end

  def query
    Order.where(user_id: @user_id).order('orders.created_at DESC')
         .limit(1)
         .includes(:addresses, :credit_card, :shipment, :coupon,
                   order_items: [:book])
         .where('addresses.address_type' => 'billing')
  end
end
