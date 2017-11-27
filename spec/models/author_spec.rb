describe Author, type: :model do
  context 'association' do
    it { is_expected.to have_and_belong_to_many(:books) }
  end
end
