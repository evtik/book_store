class BookWithAssociated < Rectify::Query
  def initialize(id, options)
    @id = id
    @load_reviews = options[:load_reviews]
  end

  def query
    books = Book.where(id: @id).includes(:authors, :materials)
    if @load_reviews
      books.includes(approved_reviews: [user: :billing_addresses])
    else
      books
    end
  end
end
