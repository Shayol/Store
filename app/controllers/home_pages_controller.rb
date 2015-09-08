class HomePagesController < ApplicationController
  def home
    @books = Book.all.take(3)
    #@books = OrderItem.group(:book).count(:quantity).
  end
end
