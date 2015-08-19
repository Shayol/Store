class CheckoutAddressForm
  include ActiveModel::Model
  include Virtus.model

  ADDRESS_ATTRIBUTES = ["firstname", "lastname", "address", "zipcode", "city", "phone", "country_id"]

  attribute :billing_firstname, String
  attribute :billing_lastname, String
  attribute :billing_address, String
  attribute :billing_zipcode, String
  attribute :billing_city, String
  attribute :billing_phone, String
  attribute :billing_country_id, Integer
  attribute :billing_as_shipping, Boolean, default: true

  attribute :shipping_firstname, String
  attribute :shipping_lastname, String
  attribute :shipping_address, String
  attribute :shipping_zipcode, String
  attribute :shipping_city, String
  attribute :shipping_phone, String
  attribute :shipping_country_id, Integer


  validates :billing_firstname, :billing_lastname, :billing_address,
            :billing_zipcode, :billing_city, :billing_phone, :billing_country_id,
            presence: true

 validates  :shipping_firstname, :shipping_lastname, :shipping_address,
            :shipping_zipcode, :shipping_city, :shipping_phone, :shipping_country_id,
            presence: true, if: :billing_as_shipping

  def save(order)
    if valid?
      persist!(order)
      true
    else
      false
    end
  end

  def persisted?
    false
  end

  def populate(billing, shipping)
    ADDRESS_ATTRIBUTES.each do |attr|
      eval("self.billing_#{attr} = billing.#{attr}")
      eval("self.shipping_#{attr} = shipping.#{attr}")
  end

  end

  private

  def persist!(order)
    order.billing_address.update!(billing_address_params)
    :billing_as_shipping ? order.shipping_address.update!(billing_address_params) : order.shipping_address.update!(shipping_address_params)
  end

  def billing_address_params
    {firstname: billing_firstname, lastname: billing_lastname, address: billing_address, city: billing_city, country_id: billing_country_id, zipcode: billing_zipcode, phone: billing_phone}
  end

  def shipping_address_params
    {firstname: shipping_firstname, lastname: shipping_lastname, address: shipping_address, city: shipping_city, country_id: shipping_country_id, zipcode: shipping_zipcode, phone: shipping_phone}
  end
end
