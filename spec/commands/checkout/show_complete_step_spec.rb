include Rails.application.routes.url_helpers

describe Checkout::ShowCompleteStep do
  describe '#call' do
    it "with visiting 'complete' step page without placing an order "\
    'in the previous step publishes :denied and redirects to cart' do
      expect { described_class.new(nil, nil).call(nil, {}) }.to(
        publish(:denied, cart_path)
      )
    end

    context 'with confirmed order' do
      let(:order) do
        build(:order, user: build(:user),
                      order_items: build_list(:order_item, 2))
      end
      let(:last_order) { double('UserLastOrder', new: [order]) }
      let(:user_id) { double('GetUserIdFromSession', call: 1) }
      let(:flash) do
        ActionDispatch::Flash::FlashHash.new(order_confirmed: true)
      end

      it "ensures flash.keep for accessing 'complete' page on reloads" do
        expect(flash).to receive(:keep)
        described_class.new(last_order, user_id).call(nil, flash)
      end

      it 'publishes :ok passing decorated order and order_items variables' do
        command = described_class.new(last_order, user_id)
        expect { command.call(nil, flash) }.to(
          publish(:ok, order: order.decorate, order_items: order.order_items)
        )
      end
    end
  end
end
