class RaitingsController < ApplicationController
  before_action :find_book, only: [:new, :create]
  before_action :authenticate_user!

  def new
    @rating = Raiting.new
  end

  def create
    @rating = current_user.raitings.build(raiting_params)
    if @rating.save
      redirect_to @book, notice: "Thank you for review! It will appear on this page after moderation."
    else
      render 'new'
    end
  end

  private
  def raiting_params
    params.require(:raiting).permit(:review, :raiting_number, :book_id)
  end

  def find_book
    @book = Book.find(params[:book_id])
  end
end
