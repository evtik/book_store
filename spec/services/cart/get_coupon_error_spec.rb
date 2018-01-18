describe Cart::GetCouponError do
  describe '.call' do
    it "returns 'does not exist' message" do
      result = described_class.call([true, false])
      expect(result).to eq(t('coupon.non_existent'))
    end

    it "returns 'taken' message" do
      result = described_class.call([false, true])
      expect(result).to eq(t('coupon.taken'))
    end

    it "returns 'expired' message" do
      result = described_class.call([false, false, true])
      expect(result).to eq(t('coupon.expired'))
    end
  end
end
