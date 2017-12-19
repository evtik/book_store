module Checkout
  class SubmitPaymentStep < BaseCommand
    def self.build
      new(Checkout::UpdateOrder.build)
    end

    def initialize(order_updater)
      @order_updater = order_updater
    end

    def call(session, params, _flash)
      order = @order_updater.call(session, params.require(:order).permit!.to_h)
      return publish(:ok, checkout_confirm_path) if order.card.valid?
      publish(:error, checkout_payment_path)
    end
  end
end
