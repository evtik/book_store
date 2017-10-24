module Checkout
  class PopulateOrderAddresses < BaseService
    def call(order, order_hash)
      order.addresses << Address.new(order_hash['billing'].except!('id'))
      return if order_hash['use_billing']
      order.addresses << Address.new(order_hash['shipping'].except!('id'))
    end
  end
end
