class Book < ApplicationRecord
  REGEXP = /\A([\p{Alnum}!#$%&'*+-\/=?^_`{|}~\s])+\z/

  belongs_to :category
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :materials
  has_many :order_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :approved_reviews, -> { where(state: 'approved') },
           class_name: 'Review'

  accepts_nested_attributes_for :authors

  mount_uploader :main_image, ImageUploader
  mount_uploaders :images, ImageUploader

  validate :must_have_category, :must_have_authors, :must_have_materials

  validates :title,
            presence: true,
            format: { with: REGEXP, message: 'Invalid book title format' },
            length: { maximum: 80 }
  validates :description,
            presence: true,
            format: { with: REGEXP, message: 'Invalid book description format' },
            length: { maximum: 1000 }
  validates :year, numericality: {
    only_integer: true,
    greater_than: 1990,
    less_than_or_equal_to: Date.today.year
  }
  validates :height, numericality: {
    greater_than: 7,
    less_than: 16
  }
  validates :width, numericality: {
    greater_than: 3,
    less_than: 8
  }
  validates :thickness, numericality: {
    greater_than: 0,
    less_than: 4
  }
  validates :price, numericality: {
    greater_than_or_equal_to: 0.50,
    less_than_or_equal_to: 199.95
  }

  def must_have_category
    errors.add(:base, 'Must have a category') if category.nil?
  end

  def must_have_authors
    errors.add(:base, 'Must be at least one author') if authors.empty?
  end

  def must_have_materials
    errors.add(:base, 'Must be at least one material') if materials.empty?
  end
end
