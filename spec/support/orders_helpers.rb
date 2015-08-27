module OrdersHelpers
  def add_book_to_order
    book = create :book
    visit book_path(book)
    click_button "ADD BOOK"
  end
end