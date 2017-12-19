module Checkout
  class SubmitAddressStep < BaseCommand
    def self.build
      new(Checkout::UpdateOrder.build)
    end

    def initialize(order_updater)
      @order_updater = order_updater
    end

    def call(session, params, _flash)
      order = @order_updater.call(session, params.require(:order).permit!.to_h)
      return publish(:ok, checkout_delivery_path) if order.addresses_valid?
      publish(:error, checkout_address_path)
    end
  end
end
