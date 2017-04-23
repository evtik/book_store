module CatalogHelper
  SORTERS = {
    { 'sort_by' => 'created_at', 'order' => 'desc' } => 'Newest first',
    { 'sort_by' => 'popular', 'order' => 'desc' } => 'Popular first',
    { 'sort_by' => 'price', 'order' => 'asc' } => 'Price: Low to high',
    { 'sort_by' => 'price', 'order' => 'desc' } => 'Price: High to low',
    { 'sort_by' => 'title', 'order' => 'asc' } => 'Title: A-Z',
    { 'sort_by' => 'title', 'order' => 'desc' } => 'Title: Z-A'
  }.freeze

  def more_books?
    limit = params[:limit].to_i
    category_id = params[:category].to_i
    if category_id.zero?
      limit < @categories.first.second
    else
      limit < find_category(category_id).second
    end
  end

  def find_category(id)
    @categories.select { |category| category[0][1].to_i == id }.first
  end

  def current_category?(id = nil)
    id == params[:category].to_i || (id.nil? && params[:category].nil?)
  end
end
