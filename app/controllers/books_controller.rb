class BooksController < ApplicationController

  load_and_authorize_resource

  def index
    @books = Book.all.page params[:page]
    @categories = Category.all
  end

  def show
  end

  def add_to_order
    if current_or_guest_user.current_order.order_book(@book, params[:addBook][:quantity].to_i)
      flash[:notice] = "Book successfully added"
    else
      flash[:alert] = "Book wasn't added"
    end
    redirect_to cart_path
  end

  def search
    @books = Book.search(params[:search]).page params[:page]
    @categories = Category.all
    flash[:alert] = "No books found." if @books.empty?
    render 'index'
  end

end
