describe BooksSorter do
  context '#query' do
    context 'by popularity' do
      subject { BooksSorter.new('sort_by' => 'popular') }

      it 'sorts books by their overall quantity(not count) in orders' do
        books = []

        4.times do |n|
          book = create(:book_with_authors_and_materials)
          n != 3 ? book.order_items << create_list(:order_item, n + 1)
                 : book.order_items << create(:order_item, quantity: 20)
          books << book
        end

        returned_books = subject.query.to_a

        expect(returned_books.map(&:title)).to match_array(
          books.reverse.map(&:title))
      end
    end
  end
end
