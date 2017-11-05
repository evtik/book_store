module Orders
  class GetOrderAddresses < BaseService
    def call(order)
      billing = order.addresses.where(address_type: 'billing').first
      shipping = order.addresses.where(address_type: 'shipping').first
      [billing, shipping || billing]
    end
  end
end
