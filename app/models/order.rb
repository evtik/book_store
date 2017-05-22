class Order < ApplicationRecord
  belongs_to :user
  belongs_to :shipment
  belongs_to :coupon
  has_many :order_items, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_one :credit_card, dependent: :destroy
end
