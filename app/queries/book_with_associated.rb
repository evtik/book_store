class BookWithAssociated < Rectify::Query
  def initialize(id, options)
    @id = id
    @include_reviews = options[:load_reviews]
  end

  def query
    books = Book.where(id: @id).eager_load(:authors, :images, :materials)
    @include_reviews ? books.eager_load(approved_reviews: :user) : books
  end
end
