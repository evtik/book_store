module CatalogHelper
  SORTERS = {
    { 'sort_by' => 'created_at', 'order' => 'desc' } =>
      I18n.t('catalog.catalog_sorters.newest'),
    { 'sort_by' => 'popular', 'order' => 'desc' } =>
      I18n.t('catalog.catalog_sorters.popular'),
    { 'sort_by' => 'price', 'order' => 'asc' } =>
      I18n.t('catalog.catalog_sorters.price_low'),
    { 'sort_by' => 'price', 'order' => 'desc' } =>
      I18n.t('catalog.catalog_sorters.price_high'),
    { 'sort_by' => 'title', 'order' => 'asc' } =>
      I18n.t('catalog.catalog_sorters.title_az'),
    { 'sort_by' => 'title', 'order' => 'desc' } =>
      I18n.t('catalog.catalog_sorters.title_za')
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
