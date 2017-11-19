class BookWithAssociated < Rectify::Query
  def initialize(id, options = {})
    @id = id
    @load_reviews = options[:load_reviews]
  end

  def query
    books = Book.where(id: @id).includes(:authors, :materials)
    return books unless @load_reviews
    books.includes(
      order_items: [order: :user],
      approved_reviews: [user: :billing_address]
    )
  end
end
