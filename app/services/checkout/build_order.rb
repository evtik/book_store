module Checkout
  class BuildOrder < BaseService
    def call(order_hash)
      OrderForm.from_params(order_hash).tap(&:valid?)
    end
  end
end
