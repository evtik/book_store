class CatalogController < ApplicationController
  def index
    @books = Book.page params[:page]
  end
end
