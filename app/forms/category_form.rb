class CategoryForm < Rectify::Form
  attribute :name, String

  validates :name,
            presence: true,
            format: { with: /\A[A-z\-\/\s]+\z/ },
            length: { maximum: 30 }
end
