class BooksController < ApplicationController
  def show
    flash[:referrer] ||= request.referrer
    flash.keep
    @book = Book.find(params[:id]).decorate
  end
end
