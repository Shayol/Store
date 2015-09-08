class CategoriesController < ApplicationController
  load_resource

  def show
    @category_books = Book.where(category: @category).page params[:page]
  end

  def index
  end
end
