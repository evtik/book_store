module Checkout
  class BuildOrder < BaseService
    def call(session)
      return unless session[:order]
      order_params = session[:order].merge(
        items_total: session[:items_total],
        subtotal: session[:order_subtotal]
      )
      OrderForm.from_params(order_params).tap(&:valid?)
    end
  end
end
