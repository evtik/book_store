class Book < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :materials
  has_many :reviews
  has_many :order_items

  paginates_per 12
end
