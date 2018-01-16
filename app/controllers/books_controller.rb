class BooksController < ApplicationController
  include Rectify::ControllerHelpers

  def show
    present(ReviewsPresenter.new)
    session[:back_to_catalog] = request.referrer
    @book = BookWithAssociated.new(params[:id], load_reviews: true)
                              .first.decorate
  end
end
