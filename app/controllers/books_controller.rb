class BooksController < ApplicationController
  def show
    flash[:referrer] ||= request.referrer
    flash[:book_page] ||= request.path
    flash.keep
    @book = BookWithAssociated.new(params[:id]).first.decorate
    @review = Review.new(book_id: @book.id)
  end
end
