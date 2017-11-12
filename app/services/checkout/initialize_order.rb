module Checkout
  class InitializeOrder < BaseService
    def self.build
      new(Common::GetOrCreateAddress.build)
    end

    def initialize(get_or_create_address)
      @get_or_create_address = get_or_create_address
    end

    def call(session)
      OrderForm.new(
        billing: @get_or_create_address.call(session, 'billing'),
        shipping: @get_or_create_address.call(session, 'shipping'),
        items_total: session[:items_total],
        subtotal: session[:order_subtotal]
      ).tap { |order| session[:order] = order }
    end
  end
end
