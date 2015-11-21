require 'rails_helper'

RSpec.feature "Categories" do
  let!(:category) { create :category }
  let!(:book) { create :book, category: category }

  it "can be found on books page" do
    visit books_path
    expect(page).to have_content category.title
  end

  it "leads to corresponding book list" do
    visit books_path
    click_link category.title
    expect(page).to have_content book.title
  end
end

