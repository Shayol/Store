class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def add_to_order book
    total_price = current_order.total_price
    current_order.add_book(book)
    if current_order.total_price != total_price
      flash[:notice] = "Book successfully added"
    else
      flash[:alert] = "Book wasn't added added"
    end
    render :show
  end

end
