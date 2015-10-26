require 'rails_helper'

RSpec.feature "Cart" do

  let(:user) { login_user }
  let(:order)      {create :order, user: user}
  let(:author)     {create :author}
  let(:book)       {create :book, author: author}

  describe "empty cart" do
    it "A user should see 'No items in your order yet.' when no items in cart" do
      visit cart_path
      expect(page).to have_content ("No items in your order yet")
    end
  end

  describe "Cart with items" do

    let!(:order_item) {create :order_item, order: order, book: book}

     before(:each) do
      allow(order).to receive(:current_order?).and_return(true)
      visit cart_path
    end

    it "User can put book in a cart" do
      visit book_path(book)
      click_button("ADD BOOK")
      visit cart_path
      expect(page).to have_content("#{book.title.titleize}")
    end

    it "leads to first page of checkout" do
      click_button("CHECKOUT")
      expect(current_path).to eq(order_checkout_path(order, "address"))
    end
  

  context "order items" do

    it "quantity can be updated by user" do
      fill_in("id-#{order_item.id}", :with  => 10)
      click_button("Update")
      #order_item.reload
      expect(page).to have_content(order_item.quantity + 10)
    end

    it "can all be deleted from cart at once" do
      click_button "EMPTY CART"
      expect(page).to have_content("Cart is empty")
    end

    it 'can be removed from cart one by one' do
      click_on("delete_item_#{order_item.id}")
      expect(page).not_to have_link("delete_item_#{order_item.id}")
      end
  end
end
end
