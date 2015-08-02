class Checkout
  include ActiveModel::Model

  attr_accessor(
    :email,
    :billing_address,
    :billing_zipcode,
    :billing_city,
    :billing_phone,
    :shipping_address,
    :shipping_zipcode,
    :shipping_city,
    :shipping_phone,
    :firstname,
    :lastname,
    :number,
    :expiration_month,
    :expiration_year,
    :terms_of_service
  )

  validates :email, presence: true
  validates :address, presence: true
  validates :zipcode, presence: true
  validates :city, presence: true
  validates :phone, presence: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :number, presence: true
  validates :expiration_year, presence: true
  validates :expiration_month, presence: true
  validates :terms_of_service, acceptance: true

  def confirm_checkout
    if valid?
      create_creditCard
      create_billing_address
      create_shipping_address
      # Do something interesting here
      # - create user
      # - send notifications
      # - log events, etc.
      current_user.orders.in_progress.first.state = ORDER_STATE[1]
    end
  end

  private

  def create_creditCard
    current_user.credit_card.create() # credit card can exist already -> then update
  end

  def create_billing_address
    address = Address.create()
    current_user.billing_address_id = address.id
  end

  def create_shipping_address
    address = Address.create()
    current_user.shipping_address_id = address.id
  end
end

<!-- <div class="row">
  <div class="col-md-2">
    <%= f.text_field :firstname, placeholder: "First name" %>
  </div>
</div>
<div class="row">
  <div class="col-md-2">
    <%= f.text_field :lastname, placeholder: "Last name" %>
  </div>
</div> -->