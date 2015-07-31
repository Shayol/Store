class CategoriesController < ApplicationController
  def show
    @categories = Category.all
    @category = Category.find(params[:id])
    @category_books = Book.where(category: @category).page params[:page]
  end
  def index
    @categories = Category.all
  end
end
