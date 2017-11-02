describe Checkout::BuildOrder do
  describe '#call' do
    let(:order_hash) { { 'billing' => attributes_for(:address) } }
    let(:order) { described_class.call(order_hash) }

    it 'returns OrderForm instance' do
      expect(order).to be_instance_of(OrderForm)
    end

    it 'populates order fields' do
      expect(order.billing).to be_truthy
      expect(order.billing.country).to eq('Italy')
    end

    it 'ensures returned order to have been validated' do
      expect_any_instance_of(OrderForm).to receive(:valid?)
      described_class.call(order_hash)
    end
  end
end
