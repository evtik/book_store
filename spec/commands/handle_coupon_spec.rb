describe HandleCoupon do
  describe '#call' do
    context 'with invalid inputs' do
      it "returns 'does not exist' message with non-existent coupon code" do
        command = described_class.new('goo')
        expect { command.call }.to publish(:error, t('coupon.non_existent'))
      end

      it "returns 'expired' message with expired coupon code" do
        create(:coupon, expires: Date.today - 1.day)
        command = described_class.new('123456')
        expect { command.call }.to publish(:error, t('coupon.expired'))
      end

      it "returns 'taken' message with coupon been already taken" do
        create(:coupon_with_order)
        command = described_class.new('123456')
        expect { command.call }.to publish(:error, t('coupon.taken'))
      end
    end

    context 'with valid input' do
      it 'returns coupon instance' do
        coupon = create(:coupon)
        command = described_class.new('123456')
        expect { command.call }.to publish(:ok, coupon)
      end
    end
  end
end
