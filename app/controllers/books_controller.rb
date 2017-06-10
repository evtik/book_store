class BooksController < ApplicationController
  def show
    flash[:referrer] ||= request.referrer
    flash.keep
    @book = BookWithAssociated.new(params[:id]).first.decorate
  end
end
