describe CreateOrderItemsFromCart do
  describe '#call' do
    it 'returns array of OrderItems corresponding to cart items' do
      create_list(:book_with_authors_and_materials, 3)
      cart = { 1 => 4, 2 => 8, 3 => 12 }
      described_class.new(cart).call.each.with_index do |item, index|
        expect(item).to be_instance_of(OrderItem)
        expect(item.book_id).to eq(index + 1)
        expect(item.quantity).to eq((index + 1) * 4)
      end
    end
  end
end
