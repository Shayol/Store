require 'rails_helper'

RSpec.feature "Checkouts" do

  # scenario "User be able fill in her shipping and billing address" do
  #   fill_address
  #   expect(page).to have_content I18n.t("cart.delivery.delivery")
  # end

  # scenario "sets default addresses for the user there are none" do
  #   login
  #   fill_address
  #   @user.reload
  #   expect(@user.shipping_address).not_to be_nil
  #   expect(@user.billing_address).not_to be_nil
  # end

  #   scenario "a user can use checkbox to use billing address as shipping address" do
  #     address = create :address
  #     visit cart_path(:address)

  #     # Billing address
  #     fill_in "billing_address_address", with: address.address
  #     fill_in "billing_address_zip_code", with: address.zip_code
  #     fill_in "billing_address_city", with: address.city
  #     fill_in "billing_address_phone", with: address.phone
  #     select "Ukraine", from: "billing_address_country"

  #     check 'use-billing-address'
  #     click_button I18n.t("cart.address.save_and_continue")
  #     expect(page).to have_content I18n.t("cart.delivery.delivery")
  #   end

  #   scenario "a user should choose delivery service" do
  #     fill_delivery
  #     expect(page).to have_content I18n.t("cart.payment.payment")
  #   end

  #   scenario "a user should put his credit card information" do
  #     fill_address
  #     fill_delivery
  #     fill_payment
  #     expect(page).to have_content (I18n.t"cart.confirm.place_order")
  #   end

  #   scenario "when user visit addresses step its init form with user addresses" do
  #     login
  #     add_book_to_cart
  #     visit cart_path(:address)
  #     # expect(page).to have_content user.shipping_address.address
  #     expect(page).to have_content @user.billing_address.address
  #   end

  #   scenario "a user can checkout the order" do
  #     # Put addresses to show last page
  #     fill_address
  #     fill_delivery
  #     # Actually code to test current scenario
  #     fill_payment
  #     click_link I18n.t("cart.confirm.place_order")
  #     expect(page).to have_content I18n.t("order_helper.in_queue")
  #   end

  #   scenario "when the guest authorizes its basket preserved" do
  #     add_book_to_cart

  #     user = attributes_for :user
  #     visit new_user_session_path
  #     within "#new_user" do
  #       fill_in "Email", with: user[:email]
  #       fill_in "Password", with: "password"
  #       click_button "Log in"
  #     end

  #     visit cart_path(:intro)
  #     expect(page).to have_content @book.title
  #   end
  # end
end
