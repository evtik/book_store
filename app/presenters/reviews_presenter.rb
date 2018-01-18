class ReviewsPresenter < Rectify::Presenter
  def verified_reviewer?(book, user_id)
    book.order_items.find { |order_item| order_item.order.user.id == user_id }
  end
end
