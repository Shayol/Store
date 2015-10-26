module OrdersHelpers
  def add_book_to_order
    author = create :author
    book = create(:book, author: author)
    visit book_path(book)
    click_button "ADD BOOK"
  end
end