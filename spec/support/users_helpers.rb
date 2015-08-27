module UsersHelpers
  def login_user
    # @request.env["devise.mapping"] = Devise.mappings[:user]
    user = create(:user)
    user.confirmed_at = Time.now
    user.save
    login_as(user, :scope => :user)
    user
  end

  def add_book_to_order
    author = create :author
    book = create(:book, author: author)
    visit book_path(book)
    click_button "ADD BOOK"
  end
end