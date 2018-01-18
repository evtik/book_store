describe Checkout::ShowPaymentStep do
  describe '#call' do
    it 'with no order in session publishes :denied event and '\
    'redirects to delivery step' do
      command = described_class.new(double('BuildOrder', call: nil))
      expect { command.call(nil, nil) }.to(
        publish(:denied, checkout_delivery_path)
      )
    end

    it 'with session order having no shipment set publishes :denied event '\
    'and redirects to delivery step' do
      order = OrderForm.from_params(attributes_for(:order, user: build(:user)))
      command = described_class.new(double('BuildOrder', call: order))
      expect { command.call(nil, nil) }.to(
        publish(:denied, checkout_delivery_path)
      )
    end

    context 'with session order set and having shipment' do
      let(:order) do
        OrderForm.from_params(
          attributes_for(
            :order,
            user: build(:user),
            shipment: ShipmentForm.from_model(build(:shipment))
          )
        )
      end

      let(:build_order) { double('BuildOrder', call: order) }

      it 'assigns empty CreditCardForm instance to order' do
        described_class.new(build_order).call(nil, nil)
        expect(order.card).to be_truthy
      end

      it 'publishes :ok event passing order variable' do
        command = described_class.new(build_order)
        expect { command.call(nil, nil) }.to publish(:ok, order: order)
      end
    end
  end
end
