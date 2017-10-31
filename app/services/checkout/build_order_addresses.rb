module Checkout
  class BuildOrderAddresses < BaseService
    def call(order)
      addresses = [Address.new(order['billing'].except!('id'))]
      return addresses if order['use_billing']
      addresses << Address.new(order['shipping'].except!('id'))
    end
  end
end
