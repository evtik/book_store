include Rails.application.routes.url_helpers

describe Checkout::SubmitPaymentStep do
  describe '#call' do
    let(:args) { [nil, spy('params'), nil] }

    it 'with no order in session publishes :error and redirects to '\
    'show payment step' do
      command = described_class.new(double('UpdateOrder', call: nil))
      expect { command.call(*args) }.to publish(:error, checkout_payment_path)
    end

    it 'with session order having no card set publishes :error and '\
    'redirects to show payment step' do
      command = described_class.new(double('UpdateOrder', call: OrderForm.new))
      expect { command.call(*args) }.to publish(:error, checkout_payment_path)
    end

    it 'with session order having invalid card publishes :error and '\
    'redirects to show payment step' do
      order = OrderForm.from_params(
        card: CreditCardForm.from_model(build(:credit_card, number: ''))
      )
      command = described_class.new(double('UpdateOrder', call: order))
      expect { command.call(*args) }.to publish(:error, checkout_payment_path)
    end

    it 'with session order having valid card publishes :ok and '\
    'redirects to show confirm step' do
      order = OrderForm.from_params(
        card: CreditCardForm.from_model(build(:credit_card))
      )
      command = described_class.new(double('UpdateOrder', call: order))
      expect { command.call(*args) }.to publish(:ok, checkout_confirm_path)
    end
  end
end
