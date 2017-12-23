include Rails.application.routes.url_helpers

describe Checkout::SubmitAddressStep do
  describe '#call' do
    it 'with invalid order addresses params publishes :error event '\
    'and redirects back to show address step' do
      order = OrderForm.from_params(
        use_billing: true,
        billing: attributes_for(:address, country: '')
      )
      command = described_class.new(double('UpdateOrder', call: order))
      expect { command.call(nil, spy('params'), nil) }.to(
        publish(:error, checkout_address_path)
      )
    end

    it 'with valid addresses params publishes :ok event and redirects '\
    'to show delivery step' do
      order = OrderForm.from_params(
        use_billing: true,
        billing: attributes_for(:address)
      )
      command = described_class.new(double('UpdateOrder', call: order))
      expect { command.call(nil, spy('params'), nil) }.to(
        publish(:ok, checkout_delivery_path)
      )
    end
  end
end
