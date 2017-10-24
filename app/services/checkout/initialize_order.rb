module Checkout
  class InitializeOrder < BaseService
    def self.build
      new(Common::GetOrCreateAddress.build)
    end

    def initialize(get_or_create_address)
      @get_or_create_address = get_or_create_address
    end

    def call(session)
      user_id = session['warden.user.user.key'][1][0]
      OrderForm.new(
        billing: @get_or_create_address.call(user_id, 'billing'),
        shipping: @get_or_create_address.call(user_id, 'shipping'),
        items_total: session[:items_total],
        subtotal: session[:order_subtotal]
      ).tap { |order| session[:order] = order }
    end
  end
end
