describe CategoriesCounter do
  context '#query' do
    it 'returns array of categeroies with their ids and books count' do
      categories = create_list(:category, 4)
      categories.each.with_index do |category, index|
        category.books << create_list(:book_with_authors_and_materials,
                                      index + 1, category: category)
        category.save
      end

      expect(CategoriesCounter.new.query).to match_array(
        [
          [['all'], 10],
          [['mobile development', 1], 1],
          [['photo', 2], 2],
          [['web design', 3], 3],
          [['web development', 4], 4]
        ]
      )
    end
  end
end
