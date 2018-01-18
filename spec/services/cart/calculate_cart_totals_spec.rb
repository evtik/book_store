describe Cart::CalculateCartTotals do
  describe '#call' do
    before { create_list(:book_with_authors_and_materials, 3) }

    it 'returns correct totals with no discount given' do
      session = { cart: { 1 => 2, 2 => 4, 3 => 9 } }
      result = described_class.call(session)
      expect(result).to eq([15.0, 15.0, 0.0])
    end

    it 'returns correct totals with particular discount given' do
      session = { cart: { 1 => 2, 2 => 4, 3 => 9 }, discount: 10 }
      result = described_class.call(session)
      expect(result).to eq([15.0, 13.5, 1.5])
    end
  end
end
