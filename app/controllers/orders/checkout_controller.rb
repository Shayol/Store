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
    @order = current_order
    params[:order][:state] = 'in_queue' if step == steps[-2]
    case step
    when :billing_and_shipping_address
      instance_variable_set("@#{params[:address_type]}_address", Address.find(params[:id]))
      if instance_variable_get("@#{params[:address_type]}_address").update(address_params)
        flash[:notice] = "#{params[:address_type].capitalize}  address was successfully updated."
      else
        flash[:alert] = "#{params[:address_type].capitalize} address wasn't updated. Check for errors."
      end
    when :delivery
      @order.update_attributes(order_params)
    when :payment

    end
    render_wizard instance_variable_get("@#{params[:address_type]}_address")
  end

  # def create
  #   @order = current_order
  #   case step
  #   when :billing_and_shipping_address
  #     @billing_address = @order.billing_address.create!(address_params)
  #     @billing_address = @order.billing_address
  #     #@order.update_attribute(:billing_address_id, @billing_address.id)
  #   when :delivery
  #   when :payment
  #   end
  #   redirect_to wizard_path_next
  # end

  private

  def order_params
    params.require(:order).permit(:shipping_address_id, :billing_address_id, :credit_card_id, :user_id, :delivery_id)
  end
end
