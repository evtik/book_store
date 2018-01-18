module Checkout
  class ShowPaymentStep < BaseCommand
    def self.build
      new(Checkout::BuildOrder.build)
    end

    def initialize(builder)
      @builder = builder
    end

    def call(session, _flash)
      order = @builder.call(session)
      return publish(:denied, checkout_delivery_path) unless order&.shipment
      order.card ||= CreditCardForm.new
      publish(:ok, order: order)
    end
  end
end
