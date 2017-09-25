class CategoriesCounter < Rectify::Query
  def query
    cats_hash = Category.joins(:books)
                        .group('categories.name', 'categories.id').count
    cats_hash.sort.unshift([['all'], cats_hash.values.sum])
  end
end
