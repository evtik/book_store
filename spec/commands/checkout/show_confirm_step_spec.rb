include Rails.application.routes.url_helpers

describe Checkout::ShowConfirmStep do
  describe '#call' do
    it 'with no order in session publishes :denied event and '\
    'redirects to payment step' do
      command = described_class.new(double('BuildOrder', call: nil), nil)
      expect { command.call(nil, nil) }.to(
        publish(:denied, checkout_payment_path)
      )
    end

    it 'with session order having no credit card set publishes :denied event '\
    'and redirects to payment step' do
      order = OrderForm.from_params(attributes_for(:order, user: build(:user)))
      command = described_class.new(double('BuildOrder', call: order), nil)
      expect { command.call(nil, nil) }.to(
        publish(:denied, checkout_payment_path)
      )
    end

    context 'with session order set and having CreditCardForm instance' do
      let(:order) do
        OrderForm.from_params(
          attributes_for(:order, user: build(:user))
        ).tap do |order|
          order.card = CreditCardForm.from_model(build(:credit_card))
        end
      end

      let(:order_items_builder) do
        double('BuildOrderItemsFromCart', call: [1, 2])
      end

      it 'builds order`s credit card based on CreditCardForm instance' do
        described_class.new(
          double('BuildOrder', call: order), order_items_builder
        ).call({}, nil)
        expect(order.credit_card).to be_truthy
      end

      context 'publishes :ok event' do
        it 'passing step variables with shipping address referencing billing '\
        'when use_billing set to true' do
          order.use_billing = true
          order.billing = AddressForm.from_model(build(:address))

          command = described_class.new(
            double('BuildOrder', call: order), order_items_builder
          )

          expect { command.call({}, nil) }.to(
            publish(:ok, order: order, billing: order.billing,
                         shipping: order.billing, order_items: [1, 2])
          )
        end

        it 'passing step variables with both shipping and billing addresses '\
        'when use_billing set to false' do
          order.billing = AddressForm.from_model(build(:address))
          order.shipping = AddressForm.from_model(build(:address))

          command = described_class.new(
            double('BuildOrder', call: order), order_items_builder
          )

          expect { command.call({}, nil) }.to(
            publish(:ok, order: order, billing: order.billing,
                         shipping: order.shipping, order_items: [1, 2])
          )
        end
      end
    end
  end
end
