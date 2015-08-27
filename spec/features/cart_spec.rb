require 'rails_helper'

RSpec.feature "Cart", type: :feature do
  let(:logged_user) {login_user}
  let(:order) {create :order, user: logged_user}

  describe "empty" do
    scenario "A user should see 'No items in your order yet.' when no items in cart" do
      visit order_path(order)
      expect(page).to have_content ("No items in your order yet")
    end
  end

  describe "order items" do
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_or_guest_user).and_return(logged_user)
      # allow(logged_user).to receive(:current_order).and_return(order)
      # allow(:current_order).and_return(order)
      add_book_to_order
    end
    it "quantity can be updated by user" do
      visit order_path(order)
      fill_in(find(".qty"), :with  => 10)
      click_button("Update")
      expect(find('.qty').value).to eq "10"
    end

    it "can all be deleted from cart at once" do
      visit order_path(order)
      click_button "EMPTY CART"
      expect(page).to have_content("No items in your order yet")
    end
  end
end
