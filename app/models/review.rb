class Review < ApplicationRecord
  include AASM

  REGEXP = /\A([\p{Alnum}!#$%&'*+-\/=?^_`{|}~\s])+\z/

  belongs_to :book
  belongs_to :user

  validates :title,
            presence: true,
            format: { with: REGEXP, message: 'Invalid review title format' },
            length: { maximum: 80 }

  validates :body,
            presence: true,
            format: { with: REGEXP, message: 'Invalid review body format' },
            length: { maximum: 500 }

  aasm column: 'state', whiny_transitions: false do
    state :unprocessed, initial: true
    state :approved, :rejected

    event :approve do
      transitions from: :unprocessed, to: :approved
    end

    event :reject do
      transitions from: [:unprocessed, :approved], to: :rejected
    end
  end
end
