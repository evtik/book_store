class Category < ApplicationRecord
  has_many :books

  validates :name,
            presence: true,
            format: { with: /\A[A-z-\s]+\z/,
                      message: 'invalid category name format' }
end
