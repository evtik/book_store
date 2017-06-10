class BookWithAssociated < Rectify::Query
  def initialize(id)
    @id = id
  end

  def query
    Book.includes(:authors, :images, :materials, reviews: :user)
        .where(id: @id)
        .limit(1)
  end
end
