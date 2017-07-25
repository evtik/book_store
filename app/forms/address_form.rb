class AddressForm < Rectify::Form
  fields = {
    first_name: /\A[\p{Alpha} '-]{,50}\z/,
    last_name: /\A[\p{Alpha} '-]{,50}\z/,
    street_address: /\A[\p{Alnum} ,-]{,50}\z/,
    city: /\A\p{Alpha}{,50}\z/,
    zip: /\A[0-9-]{3,10}\z/,
    phone: /\A\+\d{5,15}\z/
  }

  fields.each do |field, format|
    attribute field, String
    validates field, presence: true, format: { with: format }
  end

  attribute :country, String
  validates :country, presence: true

  attribute :address_type, String
end
