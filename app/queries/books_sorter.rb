class BooksSorter < Rectify::Query
  SORTERS = {
    { 'sort_by' => 'created_at', 'order' => 'desc' } => 'created_at DESC',
    { 'sort_by' => 'price', 'order' => 'asc' } => 'price ASC',
    { 'sort_by' => 'price', 'order' => 'desc' } => 'price DESC',
    { 'sort_by' => 'title', 'order' => 'asc' } => 'title ASC',
    { 'sort_by' => 'title', 'order' => 'desc' } => 'title DESC'
  }.freeze

  def initialize(params)
    @params = params
  end

  def query
    books = if @params['sort_by'] == 'popular'
              Book.joins(:order_items).group('books.id')
                  .order('sum(order_items.quantity) DESC')
            else
              Book.order(SORTERS[@params.slice('sort_by', 'order')])
            end

    books.includes(:authors).limit(@params['limit'])
  end
end
