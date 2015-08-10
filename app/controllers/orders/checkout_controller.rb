class Orders::CheckoutController < ApplicationController
  include Wicked::Wizard

  steps :billing_and_shipping_address, :delivery, :payment, :confirm, :complete
  before_action :get_checkout_data

  def show
    case step
    when :billing_and_shipping_addresss
    when :delivery
    when :payment
    end
    render_wizard
  end


  def update
    params[:order][:state] = 'in_queue' if step == steps[-2]
    case step
    when :billing_and_shipping_address
      instance_variable_set("@#{params[:address_type]}_address", Address.find(instance_variable_get("@#{params[:address_type]}_address").id)) ## find address id ...
      if instance_variable_get("@#{params[:address_type]}_address").update!(address_params)
        flash[:notice] = "#{params[:address_type].capitalize} address was successfully updated."
      else
        flash[:alert] = "#{params[:address_type].capitalize} address wasn't updated. Check for errors."
      end
       @rendered_variable = instance_variable_get("@#{params[:address_type]}_address")
    when :delivery
      if @order.update_attributes(order_params)
        flash[:notice] = "Delivery was successfully updated"
      else
        flash[:alert] = "Delivery wasn't updated. Check for errors."
      end
      @rendered_variable = @order
    when :payment
      if @credit_card.update_attributes(credit_card_params)
        flash[:notice] = "Credit card was successfully updated"
        else
        flash[:alert] = "Credit card wasn't updated. Check for errors."
      end
      @rendered_variable = @credit_card
    end
    render_wizard @rendered_variable
  end

  private

  def order_params
    params.require(:order).permit(:shipping_address_id, :billing_address_id, :credit_card_id, :user_id, :delivery_id)
  end

  def credit_card_params
    params.require(:credit_card).permit(:firstname, :lastname, :expiration_month, :expiration_year, :CVV, :number)
  end
end
