class HomePagesController < ApplicationController
  def home
    @books = Book.all.take(3)
  end
end
