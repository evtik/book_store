describe HandleCoupon do
  describe '#call' do
    it "returns 'does not exist' message with non-existent coupon code" do
      command = described_class.new('goo')
      expect { command.call }.to publish(:invalid, t('coupon.non_existent'))
    end
  end
end
