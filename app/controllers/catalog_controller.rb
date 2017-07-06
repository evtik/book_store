class CatalogController < ApplicationController
  def index
    @books = BookDecorator.decorate_collection(
      (CategoryBooks.new(catalog_params[:category]) |
        BooksSorter.new({
          'sort_by' => 'created_at',
          'order' => 'desc',
          'limit' => 12
        }.merge(catalog_params.to_h)))
    )
  end

  private

  def catalog_params
    params.permit(:category, :sort_by, :order, :limit)
  end
end
