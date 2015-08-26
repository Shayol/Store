require 'rails_helper'

RSpec.feature "Cart", type: :feature do
  let!(:user) {create :user}
  before { sign_in (user) }
  let(:order) {create :order, user: user}

  context "empty" do
    scenario "A user should see 'No items in your order yet.' when no items in cart" do
      visit order_path(order)
      expect(page).to have_content ("No items in your order yet")
    end
  end
end
