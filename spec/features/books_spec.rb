require 'rails_helper'

RSpec.feature "Books" do
  let(:book) { create :book }

  scenario "Most frequently bought books show up on home page" do
    order_items = create_list :order_items, 3
    visit root_path
    order_items.each do |item|
      expect(page).to have_content item.book.title
    end
  end

  scenario "Usercan see list of books" do
    books = create_list :books, 9
    visit books_path
    books.each{ |book| expect(page).to have_content book.title }
  end

  scenario "User can see book details" do
    visit book_path(book)
    expect(page).to have_content book.title
    expect(page).to have_content book.description
  end

  scenario "User can add book to cart" do
    visit book_path(book)
    click_button ("ADD BOOK")
    visit cart_path
    expect(page).to have_content book.title
  end

  scenario "Books can be searched by title" do
    visit root_path
    within ".search" do
      fill_in "Search", with: book.title
    end
    click_button "Search"
    expect(page).to have_content book.title
  end

  scenario "Books can be searched by author" do
    visit books_path
    within ".search" do
      fill_in "Search", with: book.author.lastname
    end
    click_button "Search"
    expect(page).to have_content book.title
  end
end