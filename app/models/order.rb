class Order < ApplicationRecord
  belongs_to :user
  belongs_to :shipment
  belongs_to :coupon
  has_many :order_items
  has_many :addresses
  has_one :credit_card
end
