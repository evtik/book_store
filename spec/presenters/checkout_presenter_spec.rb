describe CheckoutPresenter do
  context '#previous?' do
    it 'returns true for any previous step' do
      expect(subject.previous?('address', 'confirm')).to be true
    end

    it 'returns false for current step' do
      expect(subject.previous?('payment', 'payment')).to be false
    end

    it 'returns false for any further step' do
      expect(subject.previous?('complete', 'delivery')).to be false
    end
  end

  context '#current?' do
    it 'returns false for any previous step' do
      expect(subject.current?('delivery', 'complete')).to be false
    end

    it 'only returns true for current step' do
      expect(subject.current?('confirm', 'confirm')).to be true
    end

    it 'returns false for any further step' do
      expect(subject.current?('payment', 'address')).to be false
    end
  end
end
