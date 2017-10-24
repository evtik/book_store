module Checkout
  class InitializeOrder < BaseService
    def self.build
      new(Common::GetUserIdFromSession.build, Common::GetOrCreateAddress.build)
    end

    def initialize(*args)
      @get_user_id, @get_or_create_address = args
    end

    def call(session)
      user_id = @get_user_id.call(session)
      OrderForm.new(
        billing: @get_or_create_address.call(user_id, 'billing'),
        shipping: @get_or_create_address.call(user_id, 'shipping'),
        items_total: session[:items_total],
        subtotal: session[:order_subtotal]
      ).tap { |order| session[:order] = order }
    end
  end
end
