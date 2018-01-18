module Checkout
  class SubmitDeliveryStep < BaseCommand
    def self.build
      new(Checkout::UpdateOrder.build)
    end

    def initialize(order_updater)
      @order_updater = order_updater
    end

    def call(session, params, _flash)
      order = @order_updater.call(session, params.permit!.to_h)
      return publish(:ok, checkout_payment_path) if order&.shipment
      publish(:error, checkout_delivery_path)
    end
  end
end
