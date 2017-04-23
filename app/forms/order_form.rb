class OrderForm < Rectify::Form
  attribute :use_billing_address, Integer
  attribute :billing, AddressForm
  attribute :shipping, AddressForm
  attribute :shipment_id, Integer
  attribute :card, CreditCardForm

  def addresses_valid?
    shipping_valid = use_billing_address == 1 ||
                     (use_billing_address.zero? && shipping.valid?)
    billing.valid? && shipping_valid
  end
end
