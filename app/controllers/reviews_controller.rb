class ReviewsController < ApplicationController
  # def create
    # flash.keep
    # if current_user
      # @review = if params[:review].present?
                  # Review.new(review_params)
                # else
                  # Review.new(session[:review])
                # end
      # @review.user = current_user
      # if @review.save
        # flash[:notice] = 'Review posted!'
        # redirect_to flash[:book_page]
      # else
        # flash[:review_error] = true
        # @book = BookWithAssociated.new(review_params[:book_id]).first.decorate
        # render 'books/show'
      # end
    # else
      # session[:review] = review_params
      # redirect_to new_user_session_path
    # end
  # end

  def create
    flash.keep
    @review = Review.new(review_params)
    @review.user = current_user
    if @review.save
      flash[:notice] = 'Review posted!'
      redirect_to flash[:book_page]
    else
      flash[:review_error] = true
      @book = BookWithAssociated.new(review_params[:book_id]).first.decorate
      render 'books/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:book_id, :score, :title, :body)
  end
end
