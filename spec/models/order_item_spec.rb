describe OrderItem do
  context 'association' do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:book) }
  end
end
