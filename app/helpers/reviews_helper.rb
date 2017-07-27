module ReviewsHelper
  def verified_reviewer?(book_id, user_id)
    OrderItem.eager_load(:order)
             .exists?(book_id: book_id, 'orders.user_id' => user_id)
  end
end
