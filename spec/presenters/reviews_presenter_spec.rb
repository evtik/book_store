describe ReviewsPresenter do
  describe '#verified_reviewer?' do
    let!(:book) { create(:book_with_reviews, reviews_count: 1) }

    it 'returns falsey value (nil) if book wasn`t bought by this user' do
      expect(subject.verified_reviewer?(book, 1)).to be_falsey
    end

    it 'returns truthy value (OrderItem instance) if book was bought by this user' do
      user = User.first
      order = build(:order, user: user)
      order.order_items << build(:order_item, book: book)
      user.orders << order
      user.save
      expect(subject.verified_reviewer?(book, 1)).to be_truthy
    end
  end
end
