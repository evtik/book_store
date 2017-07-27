describe Category do
  context 'association' do
    it { is_expected.to have_many(:books).dependent(:destroy) }
  end

  context 'name' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to allow_value('Drama').for(:name) }
    it { is_expected.to allow_value('Non-fiction').for(:name) }
    it { is_expected.to allow_value('Pulp fiction').for(:name) }
    it { is_expected.to allow_value('Crime/detective').for(:name) }
    it { is_expected.not_to allow_value('Поезія').for(:name) }
    it { is_expected.not_to allow_value('Poetry 44').for(:name) }
  end
end
