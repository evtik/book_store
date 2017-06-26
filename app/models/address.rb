class Address < ApplicationRecord
  belongs_to :user
  belongs_to :order

  scope :billing, -> { where(address_type: 'billing').first }
  scope :shipping, -> { where(address_type: 'shipping').first }
end
