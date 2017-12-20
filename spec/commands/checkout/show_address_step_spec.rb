include Rails.application.routes.url_helpers

describe Checkout::ShowAddressStep do
  describe '#call' do
    context 'with cart blank or empty' do
      it 'with nil cart publishes :denied event and redirects to cart' do
        session = { cart: nil }
        expect { described_class.call(session, nil) }.to(
          publish(:denied, cart_path)
        )
      end

      it 'with empty cart publishes :denied event and redirects to cart' do
        session = { cart: {} }
        expect { described_class.call(session, nil) }.to(
          publish(:denied, cart_path)
        )
      end
    end

    context 'with books in cart' do
      let(:user) { create(:user) }
      let(:session) { { cart: { '2' => 4 } } }
      let(:countries) { ['Mali'] }
      let(:get_countries) { double('GetCountries', call: countries) }
      let(:initialized_order) { create(:order, user: user) }
      let(:initializer) { double('InitializeOrder', call: initialized_order) }

      it 'with order existing in session '\
      'publishes :ok event passing session order and countries variables' do
        session_order = create(:order, user: user)
        builder = double('BuildOrder', call: session_order)
        command = described_class.new(builder, initializer, get_countries)
        expect { command.call(session, nil) }.to(
          publish(:ok, order: session_order, countries: countries)
        )
      end

      it 'with no order in session publishes :ok event '\
      'passing new initialized order and countries variables' do
        builder = double('BuildOrder', call: nil)
        command = described_class.new(builder, initializer, get_countries)
        expect { command.call(session, nil) }.to(
          publish(:ok, order: initialized_order, countries: countries)
        )
      end
    end
  end
end
