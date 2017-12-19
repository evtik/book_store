module Checkout
  class ShowDeliveryStep < BaseCommand
    def self.build
      new(Checkout::BuildOrder.build)
    end

    def initialize(builder)
      @builder = builder
    end

    def call(session, _flash)
      order = @builder.call(session)
      return publish(:denied, checkout_address_path) unless order
      shipments = Shipment.all
      unless order.shipment
        order.shipment_id = shipments.first.id
        order.shipment = ShipmentForm.from_model(shipments.first)
      end
      publish(:ok, order: order, shipments: shipments)
    end
  end
end
