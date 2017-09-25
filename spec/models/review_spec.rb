describe Review do
  context 'associtation' do
    it { is_expected.to belong_to(:book) }
    it { is_expected.to belong_to(:user) }
  end

  context 'title' do
    include_examples 'title'
  end

  context 'body' do
    include_examples 'description', :body
  end
end
