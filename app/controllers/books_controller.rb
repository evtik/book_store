class BooksController < ApplicationController
  def show
    session[:back_to_catalog] = request.referrer
    @book = BookWithAssociated.new(params[:id], load_reviews: true)
                              .first.decorate
  end
end
