include Rails.application.routes.url_helpers

describe Checkout::SubmitDeliveryStep do
  describe '#call' do
    it 'with no order in session publishes :error and redirects to '\
    'show delivery step' do
      command = described_class.new(double('UpdateOrder', call: nil))
      expect { command.call(nil, spy('params'), nil) }.to(
        publish(:error, checkout_delivery_path)
      )
    end

    it 'with session order having no shipment set publishes :error and '\
    'redirects to show delivery step' do
      command = described_class.new(double('UpdateOrder', call: OrderForm.new))
      expect { command.call(nil, spy('params'), nil) }.to(
        publish(:error, checkout_delivery_path)
      )
    end

    it 'with session order having shipment set publishes :ok and '\
    'redirects to show payment step' do
      order = OrderForm.from_params(
        shipment: ShipmentForm.from_model(build(:shipment))
      )
      command = described_class.new(double('UpdateOrder', call: order))
      expect { command.call(nil, spy('params'), nil) }.to(
        publish(:ok, checkout_payment_path)
      )
    end
  end
end
