module Checkout
  class BuildOrder < BaseService
    def call(session)
      return unless session[:order]
      OrderForm.from_params(session[:order]).tap(&:valid?)
    end
  end
end
