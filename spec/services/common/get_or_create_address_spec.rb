describe Common::GetOrCreateAddress do
  describe '#call' do
    let(:user) { create(:user_with_address) }

    shared_examples 'returns FormObject' do
      example 'returns AddressForm instance' do
        expect(address).to be_instance_of(AddressForm)
      end
    end

    context 'with existing address' do
      let(:address) { described_class.call(user.id, 'billing') }

      include_examples 'returns FormObject'

      it 'populates fields with existing address values' do
        expect(address.country).to eq('Italy')
      end
    end

    context 'with non-existent address' do
      let(:address) { described_class.call(user.id, 'shipping') }

      include_examples 'returns FormObject'

      it 'returns address with empty fields' do
        expect(address.country).to be_nil
      end
    end
  end
end
