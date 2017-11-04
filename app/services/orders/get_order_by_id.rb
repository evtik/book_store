module Orders
  class GetOrderById < BaseService
    def call(order_id)
      Order.includes(:addresses, :credit_card, :shipment,
                     :coupon, order_items: [:book])
           .where(id: order_id)
           .first
           .decorate
    end
  end
end
