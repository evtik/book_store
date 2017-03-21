class Order < ApplicationRecord
  belongs_to :user
  belongs_to :credit_card
  belongs_to :coupon
  belongs_to :shipment
  has_many :order_items
  has_many :addresses, autosave: false
end
