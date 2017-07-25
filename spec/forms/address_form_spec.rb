describe AddressForm, type: :form do
  context 'first name' do
    it { is_expected.to validate_presence_of(:first_name) }
  end

  context 'first name' do
    include_examples 'name', :first_name
  end

  context 'last name' do
    include_examples 'name', :last_name
  end
end
