class Book < ApplicationRecord
  belongs_to(:category)
  has_and_belongs_to_many(:authors)
  has_and_belongs_to_many(:materials)
  has_many(:order_items, dependent: :destroy)
  has_many(:reviews, dependent: :destroy)
  has_many(:approved_reviews, -> { approved }, class_name: 'Review')

  mount_uploader(:main_image, ImageUploader)
  mount_uploaders(:images, ImageUploader)
end
