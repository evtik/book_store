describe Address, type: :model do
  context 'association' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:order) }
  end
end
