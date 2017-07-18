class CreditCardForm < Rectify::Form
  # fields = [
    # [:number, 'Please enter a valid credit card number',
     # /\A\d{16}\z/, 'Should consist of 16 digits exactly'],
    # [:cardholder, 'Please enter the cardholder\'s name',
     # /\A[A-Za-z]+(\s[A-Za-z]+)*\z/, 'Invalid name format'],
    # [:month_year, 'Please enter the card\'s expiry date',
     # /\A\d{2}\/\d{2}\z/, 'Invalid expiry date format'],
    # [:cvv, 'Please enter the card\'s cvv',
     # /\A\d{3,4}\z/, 'Invalid cvv format']
  # ]

  # fields.each do |field|
    # attribute field[0], String
    # validates field[0], presence: { message: field[1] },
                        # format: { with: field[2], message: field[3] }
  # end

  fields = {
    number: /\A\d{16}\z/,
    cardholder: /\A[A-Za-z]+(\s[A-Za-z]+)*\z/,
    month_year: /\A\d{2}\/\d{2}\z/,
    cvv: /\A\d{3,4}\z/
  }

  fields.each do |field, format|
    attribute field, String
    validates field, presence: true, format: { with: format }
  end

  validates_with CardLuhnValidator, CardExpiryValidator
end
