require 'rails_helper'

RSpec.feature "Users" do

  it "user can sign in" do
    user = create :user
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    expect(page).to have_content("Sign out")
  end
  
  describe "Settings" do
    let!(:user) { login_user }

    context "Billing and Shipping addresses" do

    let(:address_attr) { attributes_for :address }

    it "lets user enter default billing address" do
      visit settings_path 
      within ".billing-address" do
        fill_in "billing_address_firstname",  with: address_attr[:firstname]
        fill_in "billing_address_lastname",  with: address_attr[:lastname]
        fill_in "billing_address_address",  with: address_attr[:address]
        fill_in "billing_address_zipcode", with: address_attr[:zipcode]
        fill_in "billing_address_city",     with: address_attr[:city]
        fill_in "billing_address_phone",    with: address_attr[:phone]
        select  "Norway",     from: "billing_address_country"
        click_button "Save"
      end
      expect(page).to have_content "Billing_address was successfully saved"
    end

    it "lets user enter default shipping address" do
      visit settings_path 
      within ".shipping-address" do
        fill_in "shipping_address_firstname",  with: address_attr[:firstname]
        fill_in "shipping_address_lastname",  with: address_attr[:lastname]
        fill_in "shipping_address_address",  with: address_attr[:address]
        fill_in "shipping_address_zipcode", with: address_attr[:zipcode]
        fill_in "shipping_address_city",     with: address_attr[:city]
        fill_in "shipping_address_phone",    with: address_attr[:phone]
        select  "China",     from: "shipping_address_country"
        click_button "Save"
      end
      expect(page).to have_content "Shipping_address was successfully saved"
    end

    it "lets user edit default billing address" do
      address = create :address
      user.billing_address = address
      user.save
      visit settings_path 
      within ".billing-address" do
        fill_in "billing_address_address",  with: address_attr[:address]
        click_button "Save"
      end
      expect(find("#billing_address_address").value).to have_content address_attr[:address]
    end

    it "lets user edit default shipping address" do
      address = create :address
      user.shipping_address = address
      user.save
      visit settings_path 
      within ".shipping-address" do
        fill_in "shipping_address_address",  with: address_attr[:address]
        click_button "Save"
      end
      expect(find("#shipping_address_address").value).to eq address_attr[:address]

    end
  end


  end

end
