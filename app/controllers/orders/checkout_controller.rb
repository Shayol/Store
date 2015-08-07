class Orders::CheckoutController < ApplicationController
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
    end
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
      @order.update_attribute(:delivery_id, order_params)

    when :payment

    end
    render_wizard @billing_address
  end

  def create
    @order = current_order
    case step
    when :billing_and_shipping_address
      @billing_address = @order.billing_address.create!(address_params)
      @billing_address = @order.billing_address
      #@order.update_attribute(:billing_address_id, @billing_address.id)
    when :delivery
    when :payment
    end
    redirect_to wizard_path_next
  end

  private

  def order_params
    params.require(:order).permit(:shipping_address_id, :billing_address_id, :credit_card_id, :user_id, :delivery_id)
  end
end
