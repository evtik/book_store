describe Coupon do
  context 'association' do
    it { is_expected.to have_one(:order) }
  end
end
