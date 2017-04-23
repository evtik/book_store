class Author < ApplicationRecord
  has_and_belongs_to_many :books

  def full_name
    "#{first_name} #{last_name}"
  end
end
