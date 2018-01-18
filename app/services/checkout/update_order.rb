module Checkout
  class UpdateOrder < BaseService
    def call(session, order_params)
      OrderForm.from_params(session[:order].merge(order_params)).tap do |order|
        order.card.number.delete!('-') if order.card.present?
        session[:order] = order
      end
    end
  end
end
