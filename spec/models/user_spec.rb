describe User do
  context 'association' do
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
    it { is_expected.to have_many(:orders).dependent(:destroy) }
    it { is_expected.to have_many(:addresses).dependent(:destroy) }
    it { is_expected.to have_one(:billing_address).class_name('Address') }
  end
end
