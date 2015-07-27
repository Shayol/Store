class BooksController < ApplicationController

  before_action :find_book, only: [:show, :add_to_order]
  def index
    @books = Book.all.page params[:page]
  end

  def show
  end

  def add_to_order
    total_price = current_order.total_price
    current_order.order_book(@book, params[:addBook][:quantity].to_i)
    if current_order.total_price != total_price
      flash[:notice] = "Book successfully added"
    else
      flash[:alert] = "Book wasn't added"
    end
    redirect_to action: :show
  end

  private

  def find_book
    @book = Book.find(params[:id])
  end

end
