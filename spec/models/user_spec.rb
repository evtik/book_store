require 'cancan/matchers'

describe User do
  context 'association' do
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
    it { is_expected.to have_many(:orders).dependent(:destroy) }
    it { is_expected.to have_many(:addresses).dependent(:destroy) }
    it { is_expected.to have_one(:billing_address).class_name('Address') }
  end

  context 'abilities' do
    subject { Ability.new(user) }

    context 'admin' do
      let(:user) { create(:admin_user) }
      it { is_expected.to be_able_to(:manage, :all) }
    end

    context 'user' do
      let(:user) { create(:user) }
      it { is_expected.to be_able_to(:read, Order, user_id: user.id) }
    end
  end
end
