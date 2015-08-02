class CheckoutController < ApplicationController

  include Wicked::Wizard

  steps :billing_and_shipping_address, :delivery, :payment, :confirm, :complete

  def show
    #(address: "boooo", zipcode: "456789", city: "Monooo", country_id: 1, phone: "931431332" )
    @order = current_order
    case step
    when :billing_and_shipping_address
      @billing_address  = current_order.billing_address || current_user.billing_address || Address.new
    when :delivery
    when :payment

    render_wizard
  end


  def update
    @order = current_order
    params[:order][:state] = 'in_queue' if step == steps[-2]
    case step
    when :billing_and_shipping_address
      @order.billing_address.update_attributes(address_params)
      @billing_address = @order.billing_address
      #@order.update_attribute(:billing_address_id, @billing_address.id)
    when :delivery
    when :payment

    end
    render_wizard @billing_address
  end

  def create
    case step
    when :billing_and_shipping_address
      @billing_address = Address.create(address_params)
      @order.update_attribute(:billing_address_id, @billing_address.id)
    when :delivery
    when :payment

    end
  end
  # def new
  #   @checkout = Checkout.new
  # end

  #   def create
  #   @checkout = Checkout.new(checkout_params)
  #   @checkout.confirm_checkout

  #   # respond_with @registration, location: some_success_path
  # end

  private

  def address_params
    params.require(:address).permit(:address, :country_id, :city, :phone, :zipcode)
  end
end
