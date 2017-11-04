describe Orders::GetOrderById do
  describe '#call' do
    subject do
      create_list(:book_with_authors_and_materials, 3)
      order = build(:order)
      order.addresses = build_list(:address, 2)
      order.credit_card = build(:credit_card)
      order.shipment = build(:shipment)
      order.coupon = build(:coupon)
      order.order_items = build_list(:order_item, 3)
      order.save
      described_class.call(order.id)
    end

    it 'returns OrderDecorator instance' do
      is_expected.to be_instance_of(OrderDecorator)
    end

    it 'ensures to have preloaded order`s associated entities' do
      %i(addresses credit_card shipment coupon order_items).each do |associated|
        expect(subject.association_cached?(associated)).to be true
      end
    end

    it 'also ensures to have loaded order items` books' do
      expect(subject.order_items.first.association_cached?(:book)).to be true
    end
  end
end
