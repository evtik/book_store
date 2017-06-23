class Author < ApplicationRecord
  NAME_REGEXP = /\A[A-z\'\-\s]+\z/
  DESCRIPTION_REGEXP = /\A([\p{Alnum}!#$%&'*+-\/=?^_`{|}~\s])+\z/

  has_and_belongs_to_many :books

  %i(first_name last_name).each do |field|
    humanized = field.to_s.humanize(capitalize: false)
    validates field,
              presence: true,
              format: { with: NAME_REGEXP,
                        message: "Invalid #{humanized} format" }
  end

  validates :description,
            presence: true,
            format: { with: DESCRIPTION_REGEXP,
                      message: 'Invalid description format' }

  def full_name
    "#{first_name} #{last_name}"
  end
end
