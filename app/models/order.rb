class Order < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :shipment
  belongs_to :coupon
  has_many :order_items, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_one :credit_card, dependent: :destroy

  aasm column: 'state', whiny_transitions: false do
    state :in_progress, initial: true
    state :in_queue, :in_delivery, :delivered, :canceled

    event :queue do
      transitions from: :in_progress, to: :in_queue
    end

    event :deliver do
      transitions from: :in_queue, to: :in_delivery
    end

    event :confirm_delivery do
      transitions from: :in_delivery, to: :delivered
    end

    event :cancel do
      transitions from: [:in_progress, :in_queue], to: :canceled
    end
  end
end
