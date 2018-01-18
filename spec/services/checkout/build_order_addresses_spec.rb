describe Checkout::BuildOrderAddresses do
  describe '#call' do
    let(:order) do
      {
        'billing' => attributes_for(:address),
        'shipping' => attributes_for(:address, address_type: 'shipping')
      }
    end

    shared_examples 'returns addresses array' do
      example 'returns Array instance' do
        expect(result).to be_instance_of(Array)
      end

      example 'returns array with Address instances' do
        result.each { |address| expect(address).to be_instance_of(Address) }
      end

      example 'returns Address instances without ids' do
        result.each { |address| expect(address.id).to be_nil }
      end
    end

    context 'with order not using billing address for shipping' do
      let(:result) { described_class.call(order) }

      it 'returns both addresses' do
        expect(result.length).to eq(2)
      end

      include_examples 'returns addresses array'
    end

    context 'with order using billing address for shipping' do
      let(:result) do
        described_class.call(order.merge('use_billing' => true))
      end

      it 'only returns billing address' do
        expect(result.length).to eq(1)
        expect(result.first.address_type).to eq('billing')
      end

      include_examples 'returns addresses array'
    end
  end
end
