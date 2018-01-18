module Checkout
  class BuildCompletedOrder < BaseService
    def self.build
      new(Common::GetUserIdFromSession.build,
          Checkout::BuildOrderAddresses.build,
          Common::BuildOrderItemsFromCart.build)
    end

    def initialize(*args)
      @get_user_id, @build_addresses, @build_order_items = args
    end

    def call(session)
      order_hash = session[:order]
      Order.new(user_id: @get_user_id.call(session),
                coupon_id: session[:coupon_id],
                shipment_id: order_hash['shipment_id'],
                subtotal: order_hash['subtotal']).tap do |order|
        order.addresses = @build_addresses.call(order_hash)
        order.credit_card = CreditCard.new(order_hash['card'])
        order.order_items = @build_order_items.call(session[:cart])
      end
    end
  end
end
