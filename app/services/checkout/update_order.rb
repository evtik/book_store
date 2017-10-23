module Checkout
  class UpdateOrder < BaseService
    def call(session, order_params)
      order = OrderForm.from_params(session[:order].merge(order_params))
      order.card.number.delete!('-') if order.card.present?
      session[:order] = order
      order
    end
  end
end
