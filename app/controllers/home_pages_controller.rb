class HomePagesController < ApplicationController
  def home
    @books = Book.all
  end
end
