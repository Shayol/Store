module OrdersHelpers
  def add_book_to_order
    book = create(:book)
    visit book_path(book)
    click_button "ADD BOOK"
  end

  def fill_address(use_shipping_as_billing=true)
    address_attr = attributes_for :address
    visit order_checkout_path(@cart, "address")
      fill_in "billing_firstname",  with: address_attr[:firstname]
      fill_in "billing_lastname",  with: address_attr[:lastname]
      fill_in "billing_address",  with: address_attr[:address]
      fill_in "billing_zipcode", with: address_attr[:zipcode]
      fill_in "billing_city",     with: address_attr[:city]
      fill_in "billing_phone",    with: address_attr[:phone]
      select  "Norway",     from: "billing_country"
    unless use_shipping_as_billing
      fill_in "shipping_address_firstname",  with: address_attr[:firstname]
      fill_in "shipping_address_lastname",  with: address_attr[:lastname]
      fill_in "shipping_address_address",  with: address_attr[:address]
      fill_in "shipping_address_zipcode", with: address_attr[:zipcode]
      fill_in "shipping_address_city",     with: address_attr[:city]
      fill_in "shipping_address_phone",    with: address_attr[:phone]
      select  "China",     from: "shipping_address_country"
      click_button "SAVE AND CONTINUE"
    end
  end

  def fill_delivery
    delivery_services = []
    3.times { delivery_services << create(:delivery_service) }

    visit cart_path(:delivery)
    choose("delivery_#{delivery_services[1].id}")
    click_button I18n.t("cart.delivery.save_and_continue")
  end

  def fill_payment
    credit_card = attributes_for :credit_card
    exp_date = Date.today + 1.year
    visit cart_path(:payment)
    within "#new_credit_card" do
      fill_in "Number", with: credit_card[:number]
      fill_in "Cvv", with: credit_card[:CVV]
      select exp_date.month, from: "Expiration month"
      select exp_date.year, from: "Expiration year"
      fill_in "First name", with: credit_card[:first_name]
      fill_in "Last name", with: credit_card[:last_name]
      click_button I18n.t("cart.payment.save_and_continue")
    end
  end
end