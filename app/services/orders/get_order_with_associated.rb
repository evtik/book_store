module Orders
  class GetOrderWithAssociated < BaseService
    def call(id)
      Order.includes(:billing_address, :shipping_address, :credit_card,
                     :shipment, :coupon, order_items: [:book])
           .where(id: id)
           .first
           .decorate
    end
  end
end
