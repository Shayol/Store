class CheckoutAddressForm
  include ActiveModel::Model
  include Virtus

  attribute :billing_firstname, String
  attribute :billing_lastname, String
  attribute :billing_address, Text
  attribute :billing_zipcode, Text
  attribute :billing_city, Text
  attribute :billing_phone, Text
  attribute :billing_country_id, Integer

  attribute :shipping_firstname, String
  attribute :shipping_lastname, String
  attribute :shipping_address, Text
  attribute :shipping_zipcode, Text
  attribute :shipping_city, Text
  attribute :shipping_phone, Text
  attribute :shipping_country_id, Integer


  validates :billing_firstname, :billing_lastname, :billing_address,
            :billing_zipcode, :billing_city, :billing_phone, :billing_country_id,
            :shipping_firstname, :shipping_lastname, :shipping_address,
            :shipping_zipcode, :shipping_city, :shipping_phone, :shipping_country_id,
            presence: true

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def populate
    @billing_address  = current_or_guest_user.current_order.billing_address || current_or_guest_user.billing_address
    @shipping_address  = current_or_guest_user.current_order.shipping_address || current_or_guest_user.shipping_address

    unless @billing_address
      @billing_address = Address.new
      @billing_address.save(validate: false)
      current_or_guest_user.current_order.update_attribute(:billing_address_id, @billing_address.id)
    end

    unless @shipping_address
      @shipping_address = Address.new
      @shipping_address.save(validate: false)
      current_or_guest_user.current_order.update_attribute(:shipping_address_id, @shipping_address.id)
    end



  end

  private

  def persist!
    current_or_guest_user.current_order.biiling_address.update!(billing_address_params)
    current_or_guest_user.current_order.shipping_address.update!(shipping_address_params)
  # add sh and bill address to current user if none
  end

  def billing_address_params
    {firstname: billing_firstname, lastname: billing_lastname, address: billing_address, city: billing_city, country_id: billing_country_id, zipcode: billing_zipcode, phone: billing_phone}
  end

  def shipping_address_params
    {firstname: shipping_firstname, lastname: shipping_lastname, address: shipping_address, city: shipping_city, country_id: shipping_country_id, zipcode: shipping_zipcode, phone: shipping_phone}
  end
end
