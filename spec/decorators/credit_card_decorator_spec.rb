describe CreditCardDecorator do
  let(:card) do
    build(:credit_card,
          number: '1234567812345678',
          month_year: '11/20').decorate
  end

  it '#starred_number returns stars followed by last 4 digits' do
    expect(card.starred_number).to eq('** ** ** 5678')
  end

  it '#month_full_year returns month and 4-digit year' do
    expect(card.month_full_year).to eq('11/2020')
  end
end
