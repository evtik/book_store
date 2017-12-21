include Rails.application.routes.url_helpers

describe Checkout::ShowDeliveryStep do
  describe '#call' do
    context 'with no order in session' do
      it 'publishes :denied event and redirects to address step' do
        command = described_class.new(double('BuildOrder', call: nil))
        expect { command.call(nil, nil) }.to(
          publish(:denied, checkout_address_path)
        )
      end
    end

    context 'with order in session' do
      let!(:shipments) { create_list(:shipment, 3) }
      let(:order) do
        OrderForm.from_params(attributes_for(:order, user: build(:user)))
      end

      it 'assigns first shipment method to order if it hasn`t got one' do
        described_class.new(double('BuildOrder', call: order)).call(nil, nil)
        expect(order.shipment_id).to eq(1)
        expect(order.shipment.days_max).to eq(shipments.first.days_max)
      end

      it 'keeps existing order shipment method' do
        order = OrderForm.from_params(
          attributes_for(
            :order,
            user: build(:user),
            shipment_id: shipments[1].id,
            shipment: ShipmentForm.from_model(shipments[1])
          )
        )
        described_class.new(double('BuildOrder', call: order)).call(nil, nil)
        expect(order.shipment_id).to eq(2)
        expect(order.shipment.days_max).to eq(shipments[1].days_max)
      end

      it 'publishes :ok event passing built order and all shipments' do
        command = described_class.new(double('BuildOrder', call: order))
        expect { command.call(nil, nil) }.to(
          publish(:ok, order: order, shipments: shipments)
        )
      end
    end
  end
end
