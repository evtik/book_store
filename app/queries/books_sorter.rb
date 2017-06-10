class BooksSorter < Rectify::Query
  def initialize(params)
    @params = params
  end

  def query
    books = if @params['sort_by'] == 'popular'
              Book.joins(:order_items).group('books.id')
                  .order('count(books.id) DESC')
            else
              Book.order("#{@params['sort_by']} #{@params['order'].upcase}")
            end

    books.includes(:authors, :images).limit(@params['limit'])
  end
end
