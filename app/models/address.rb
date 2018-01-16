class Address < ApplicationRecord
  belongs_to(:user)
  belongs_to(:order)

  scope(:billing, -> { where(address_type: 'billing') })
  scope(:shipping, -> { where(address_type: 'shipping') })
end
