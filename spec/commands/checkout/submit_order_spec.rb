describe Checkout::SubmitOrder do
  describe '#call' do
    let(:user) { create(:user) }
    let(:order) { build(:order, user_id: user.id) }

    let(:session) do
      { cart: 'cart', order: 'order', discount: 1, coupon_id: 2 }
    end

    let(:mailer) { spy('NotifierMailer') }

    let(:command) do
      described_class.new(double('BuildCompletedOrder', call: order), mailer)
    end

    context 'with successful order placement' do
      before do |example|
        command.call(session) unless example.metadata[:skip_before]
      end

      it 'clears order related session keys' do
        %i(cart order discount coupon_id).each do |key|
          expect(session[key]).to be_nil
        end
      end

      it 'sends order confirmation email' do
        expect(mailer).to have_received(:order_email)
      end

      it 'creates new order in db', skip_before: true do
        expect { command.call(session) }.to change(Order, :count).by(1)
      end

      it 'publishes :ok event', skip_before: true do
        expect { command.call(session) }.to publish(:ok)
      end
    end

    context 'with failed order placement' do
      it 'publishes :error event' do
        allow(order).to receive(:save).and_return(false)
        expect { command.call(session) }.to publish(:error)
      end

      it 'logs error message when sending order email fails' do
        allow(mailer).to(
          receive_message_chain(:order_email, :deliver).and_raise(StandardError,
                                                                  'email error')
        )
        expect(Rails.logger).to receive(:debug).with(/email error/)
        command.call(session)
      end
    end
  end
end
