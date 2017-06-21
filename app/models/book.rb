class Book < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :materials
  has_many :images
  has_many :order_items
  has_many :reviews
  has_many :approved_reviews, -> { where(state: 'approved') },
           class_name: 'Review'
  accepts_nested_attributes_for :authors

  paginates_per 12
end
