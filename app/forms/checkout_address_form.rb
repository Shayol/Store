class CheckoutAddressForm
  include ActiveModel::Model
  include Virtus.model

  ADDRESS_ATTRIBUTES = ["firstname", "lastname", "address", "zipcode", "city", "phone", "country_id"]
  EXPIRATION_MONTH = (1..12).map(&:to_s)
  EXPIRATION_YEAR = (2015..2025).map(&:to_s)

  attribute :order
  attribute :step

  attribute :billing_firstname, String
  attribute :billing_lastname, String
  attribute :billing_address, String
  attribute :billing_zipcode, String
  attribute :billing_city, String
  attribute :billing_phone, String
  attribute :billing_country, String
  attribute :use_billing_as_shipping, Boolean, default: true

  attribute :shipping_firstname, String
  attribute :shipping_lastname, String
  attribute :shipping_address, String
  attribute :shipping_zipcode, String
  attribute :shipping_city, String
  attribute :shipping_phone, String
  attribute :shipping_country, String

  attribute :card_firstname, String
  attribute :card_lastname, String
  attribute :card_expiration_month, String
  attribute :card_expiration_year, String
  attribute :card_CVV, String
  attribute :card_number, String

  attribute :delivery_id, Integer

  attribute :form_completed_date, DateTime




  validates :billing_firstname, :billing_lastname, :billing_address,
            :billing_zipcode, :billing_city, :billing_phone, :billing_country,
            presence: true, if: Proc.new { step == :address }

  validates :shipping_firstname, :shipping_lastname, :shipping_address,
            :shipping_zipcode, :shipping_city, :shipping_phone, :shipping_country,
            presence: true, unless: :not_address_step_and_same_as_billing?

  validates :card_firstname, :card_lastname, :card_expiration_month,
            :card_expiration_year, :card_CVV, :card_number,
             presence: true,  if: Proc.new { step == :payment }

  validates :card_expiration_month, inclusion: { in: EXPIRATION_MONTH },  if: Proc.new { step == :payment }
  validates :card_expiration_year, inclusion: { in: EXPIRATION_YEAR },  if: Proc.new { step == :payment }
  validates :card_CVV, length: 3..4,  if: Proc.new { step == :payment }
  validates :card_number, length: 13..16,  if: Proc.new { step == :payment }

  validates :delivery_id, presence: true, if: Proc.new { step == :delivery }

  validates :form_completed_date, presence: true, if: Proc.new { step == :confirm }

  def not_address_step_and_same_as_billing?
    step != :address || use_billing_as_shipping
  end

  def save
    if valid?
      persist!
      order.save!
      true
    else
      false
    end
  end

  def persisted?
    false
  end

  def populate
    case step
      when :address
        ADDRESS_ATTRIBUTES.each do |attr|
          eval("self.billing_#{attr} = order_billing_address.#{attr}")
          eval("self.shipping_#{attr} = order_shipping_address.#{attr}")
        end
      when :delivery
        self.delivery_id = order_delivery
      when :payment
        self.card_firstname = order_credit_card.firstname
        self.card_lastname = order_credit_card.lastname
        self.card_expiration_month = order_credit_card.expiration_month
        self.card_expiration_year = order_credit_card.expiration_year
        self.card_CVV = order_credit_card.CVV
        self.card_number = order_credit_card.number
      when :confirm
        self.form_completed_date = order_completed_date
      end

  end

  def order_billing_address
    order.billing_address || order.user.billing_address || Address.new
  end

  def order_shipping_address
    order.shipping_address || order.user.shipping_address || Address.new
  end

  def order_credit_card
    order.credit_card || CreditCard.new
  end

  def order_delivery
    order.delivery_id || nil
  end

  def order_completed_date
    order.completed_date || nil
  end

  def create_addresses
    shipping_address_params = billing_address_params if use_billing_as_shipping
    if order.billing_address && order.shipping_address
      order.billing_address.update(billing_address_params)
      order.shipping_address.update(shipping_address_params)
    else
      order.create_billing_address(billing_address_params)
      order.create_shipping_address(shipping_address_params)
    end
  end

  def create_delivery
    if Delivery.find_by_id(delivery_params[:delivery_id])
      order.update(delivery_params)
    end
  end

  def create_credit_card
    if order.credit_card
      order.credit_card.update(credit_card_params)
    else
      order.create_credit_card(credit_card_params)
    end
  end

  def create_confirm
    order.update(confirm_params)  ### check this!!!
    order.confirm_event!
  end

  def persist!
    case step
      when :address
        create_addresses
      when :delivery
        create_delivery
        order.set_total_price
      when :payment
        create_credit_card
      when :confirm
        order.set_total_price
        create_confirm
      when :complete

    end
  end

  private

  def confirm_params
    {completed_date: form_completed_date}
  end

  def delivery_params
    {delivery_id: delivery_id}
  end

  def credit_card_params
    {firstname: card_firstname, lastname: card_lastname, expiration_month: card_expiration_month, expiration_year: card_expiration_year, CVV: card_CVV, number: card_number}
  end

  def billing_address_params
    {firstname: billing_firstname, lastname: billing_lastname, address: billing_address, city: billing_city, country: billing_country, zipcode: billing_zipcode, phone: billing_phone}
  end

  def shipping_address_params
    {firstname: shipping_firstname, lastname: shipping_lastname, address: shipping_address, city: shipping_city, country: shipping_country, zipcode: shipping_zipcode, phone: shipping_phone}
  end
end
