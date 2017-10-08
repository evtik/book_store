describe HandleCoupon do
  describe '#call' do
    it "returns 'does not exist' message with non-existent coupon code" do
      command = described_class.new('goo')
      expect { command.call }.to publish(:invalid, 'This coupon does not exist!')
    end
  end
end
