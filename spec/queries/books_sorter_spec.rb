describe BooksSorter do
  context '#query' do
    context 'newest first' do
      it 'sorts books by their recency' do
        books = create_list(:book_with_authors_and_materials, 10)
        sorter = BooksSorter.new('sort_by' => 'created_at', 'order' => 'desc')
        returned_books = sorter.query.to_a.map(&:title)
        expect(returned_books).to eq(books.reverse.map(&:title))
      end
    end

    context 'popular first' do
      it 'sorts books by their overall quantity(not count) in orders' do
        sorter = BooksSorter.new('sort_by' => 'popular')
        books = []
        4.times do |n|
          book = create(:book_with_authors_and_materials)
          n != 3 ? book.order_items << create_list(:order_item, n + 1)
                 : book.order_items << create(:order_item, quantity: 20)
          books << book
        end
        returned_books = sorter.query.to_a.map(&:title)
        expect(returned_books).to eq(books.reverse.map(&:title))
      end
    end

    context 'by price' do
      let!(:books) do
        books = []
        4.times do |n|
          books << create(:book_with_authors_and_materials, price: 1.0 + n)
        end
        books.map(&:title)
      end

      scenario 'sorts books by price from low to high' do
        sorter = BooksSorter.new('sort_by' => 'price', 'order' => 'asc')
        returned_books = sorter.query.to_a.map(&:title)
        expect(returned_books).to eq(books)
      end

      scenario 'sorts books by price from high to low' do
        sorter = BooksSorter.new('sort_by' => 'price', 'order' => 'desc')
        returned_books = sorter.query.to_a.map(&:title)
        expect(returned_books).to eq(books.reverse)
      end
    end

    context 'by title' do
      let!(:books) do
        books = []
        [*'a'..'f'].each do |char|
          books << create(:book_with_authors_and_materials,
                          title: "#{char} title")
        end
        books.map(&:title)
      end

      scenario 'sorts books by title from a to z' do
        sorter = BooksSorter.new('sort_by' => 'title', 'order' => 'asc')
        returned_books = sorter.query.to_a.map(&:title)
        expect(returned_books).to eq(books)
      end

      scenario 'sorts books by title from z to a' do
        sorter = BooksSorter.new('sort_by' => 'title', 'order' => 'desc')
        returned_books = sorter.query.to_a.map(&:title)
        expect(returned_books).to eq(books.reverse)
      end
    end
  end
end
