describe Author, type: :model do
  context 'association' do
    it { is_expected.to have_and_belong_to_many(:books) }
  end

  context 'first name' do
    include_examples 'name', :first_name
  end

  context 'last name' do
    include_examples 'name', :last_name
  end

  context 'description' do
    include_examples 'description', :description
  end
end
