describe Orders::GetOrderAddresses do
  describe '#call' do
    shared_examples 'addresses array' do
      example 'returns Array instance' do
        is_expected.to be_an_instance_of(Array)
      end

      example 'returns array of Address instances' do
        subject.each { |address| expect(address).to be_an_instance_of(Address) }
      end

      example 'always returns 2 addresses in array' do
        expect(subject.length).to eq(2)
      end
    end

    context 'with order only having billing address' do
      subject do
        order = build(:order)
        order.addresses << build(:address)
        order.save
        described_class.call(order)
      end

      include_examples 'addresses array'

      it 'returns array of 2 same billing address references' do
        expect(subject.first).to equal(subject.last)
      end
      it 'returns order billing address' do
        expect(subject.first.address_type).to eq('billing')
        expect(subject.first.country).to eq('Italy')
      end
    end

    context 'with order having both addresses' do
      subject do
        order = build(:order)
        order.addresses << build(:address)
        order.addresses << build(:address,
                                 address_type: 'shipping',
                                 country: 'Alemania')
        order.save
        described_class.call(order)
      end

      include_examples 'addresses array'

      it 'returns array of different addresses' do
        expect(subject.first).not_to equal(subject.last)
      end

      it 'returns shipping address as the second item' do
        expect(subject.second.address_type).to eq('shipping')
        expect(subject.second.country).to eq('Alemania')
      end
    end
  end
end
