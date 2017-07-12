class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def new
    @book = BookWithAssociated.new(params[:book_id], load_reviews: false)
                              .first.decorate
    @review = Review.new(book_id: @book.id, score: 0)
  end

  def create
    @review = Review.new(review_params)
    @review.user = current_user
    if @review.save
      flash[:notice] = t 'reviews.form.success_message'
      redirect_to book_path(params[:book_id])
    else
      @book = BookWithAssociated
        .new(review_params[:book_id], load_reviews: false).first.decorate
      render 'new'
    end
  end

  private

  def review_params
    params.require(:review).permit(:book_id, :score, :title, :body)
  end
end
