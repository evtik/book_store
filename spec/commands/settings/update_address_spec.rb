include AbstractController::Translation

describe Settings::UpdateAddress do
  describe '#call' do
    let(:user) { create(:user) }
    let(:address) { create(:address, user_id: user.id) }
    let(:message) { 'updated!' }

    let(:command) do
      described_class.new(
        double('FindOrInitializeAddress', call: address),
        double('GenerateAddressUpdatedMessage', call: message)
      )
    end

    let(:params) do
      {
        'billing' => t('settings.show.save'),
        address: {
          'billing' => attributes_for(:address)
        }
      }
    end

    context 'with non-valid address params' do
      it 'publishes :invalid event' do
        invalid_params = {
          'billing' => t('settings.show.save'),
          address: { 'billing' => attributes_for(:address, phone: 'abc') }
        }
        expect { command.call(invalid_params, user.id) }.to publish(:invalid)
      end
    end

    context 'with valid address params' do
      context 'with successfully saved address' do
        it 'publishes :ok event with updating success message' do
          expect { command.call(params, user.id) }.to publish(:ok, message)
        end
      end

      context 'with saving address failed' do
        it 'publishes :error event with db error message' do
          allow(address).to receive(:save).and_return(false)
          error_message = 'db error!!!'
          allow(address).to receive_message_chain(
            :errors, full_messages: [error_message]
          )
          expect { command.call(params, user.id) }.to publish(:error,
                                                              error_message)
        end
      end
    end
  end
end
