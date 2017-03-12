class HomeController < ApplicationController
  def index
    @latest_books = Book.order(created_at: :desc).limit(3)
    @most_popular_books = Book.joins(:order_items).group('books.id')
                              .order('count(books.id) DESC').limit(4)
  end
end
