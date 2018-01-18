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

  context 'callbacks' do
    it 'logs error message when sending welcome email fails' do
      user = User.new(attributes_for(:user))
      allow(NotifierMailer).to(
        receive_message_chain(:user_email, :deliver).and_raise(StandardError,
                                                               'weird error')
      )
      expect(Rails.logger).to receive(:debug).with(/weird error/)
      user.save
    end
  end
end
