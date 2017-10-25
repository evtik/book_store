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

    context 'with valid order' do
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

    context 'with invalid order' do
      it 'publishes :error event with error message' do
        allow_any_instance_of(Order).to receive(:save).and_return(false)
        error_message = 'some error'
        allow_any_instance_of(Order).to receive_message_chain(
          :errors, full_messages: [error_message]
        )
        expect { command.call(session) }.to publish(:error, error_message)
      end
    end
  end
end
