class BookWithAssociated < Rectify::Query
  def initialize(id, options)
    @id = id
    @load_reviews = options[:load_reviews]
  end

  def query
    books = Book.where(id: @id).eager_load(:authors, :materials)
    if @load_reviews
      books.eager_load(approved_reviews: [user: :billing_addresses])
    else
      books
    end
  end
end
