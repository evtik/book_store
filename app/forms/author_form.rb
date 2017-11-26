class AuthorForm < Rectify::Form
  attribute :first_name, String
  attribute :last_name, String
  attribute :description, String

  NAME_REGEXP = /\A[\p{Alpha} '-]+\z/
  DESCRIPTION_REGEXP = /\A([\p{Alnum}!#$%&'*+-\/=?^_`{|}~\s])+\z/

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
end
