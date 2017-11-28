describe Review do
  context 'associtation' do
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:user) }
  end

  context 'scopes' do
    context 'approved' do
      let!(:unprocessed) { create(:review, state: 'unprocessed') }
      let!(:approved) { create(:review) }
      let!(:rejected) { create(:review, state: 'rejected') }

      it 'only returns approved reviews' do
        expect(described_class.approved.count).to eq(1)
      end

      it 'does not return unprocessed and rejected reviews' do
        expect(described_class.approved).not_to include(unprocessed, rejected)
      end
    end
  end
end
