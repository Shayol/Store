class BooksController < ApplicationController

  load_and_authorize_resource

  def index
    @books = Book.all.page params[:page]
    @categories = Category.all
  end

  def show
  end

  def search
    @books = Book.search(params[:search]).page params[:page]
    @categories = Category.all
    flash[:alert] = "No books found." if @books.empty?
    render 'index'
  end

end
