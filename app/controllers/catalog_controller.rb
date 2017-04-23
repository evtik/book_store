class CatalogController < ApplicationController
  def index
    @books = BookDecorator.decorate_collection(
      (CategoryBooks.new(params[:category]) |
        BooksSorter.new({
          'sort_by' => 'created_at',
          'order' => 'desc',
          'limit' => 12
        }.merge(params)))
    )
  end
end
