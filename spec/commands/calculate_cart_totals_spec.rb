describe CalculateCartTotals do
  describe '#call' do
    let(:cart) { { 1 => 2, 2 => 4, 3 => 9 } }

    before { create_list(:book_with_authors_and_materials, 3) }

    it 'returns correct totals with no discount given' do
      result = described_class.new(cart).call
      expect(result).to eq([15.0, 0.0, 15.0])
    end

    it 'returns correct totals with particular discount given' do
      result = described_class.new(cart, 10.0).call
      expect(result).to eq([15.0, 1.5, 13.5])
    end
  end
end
