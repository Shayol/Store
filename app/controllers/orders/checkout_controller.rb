class Orders::CheckoutController < ApplicationController
  include Wicked::Wizard

  steps :billing_and_shipping_address, :delivery, :payment, :confirm, :complete

  def show
    case step
    when :billing_and_shipping_address
      @address = CheckoutAddressForm.new
      get_checkout_address_data
      @address.populate(@billing_address, @shipping_address)
    when :delivery
      get_order
    when :payment
      get_credit_card
    end
    render_wizard
  end


  def update
    params[:order][:state] = 'in_queue' if step == steps[-2]
    case step
    when :billing_and_shipping_address
      @address = CheckoutAddressForm.new(checkout_address_form_params)
      if @address.save
          flash[:notice] = "Successfully updated addresses"
        else
          flash[:alert] = "Check for errors"
        end
        @rendered_variable = @address
      # instance_variable_set("@#{params[:address_type]}_address", Address.find(instance_variable_get("@#{params[:address_type]}_address").id)) ## find address id ...
      # if instance_variable_get("@#{params[:address_type]}_address").update!(address_params)
      #   flash[:notice] = "#{params[:address_type].capitalize} address was successfully updated."
      # else
      #   flash[:alert] = "#{params[:address_type].capitalize} address wasn't updated. Check for errors."
      # end
      #  @rendered_variable = instance_variable_get("@#{params[:address_type]}_address")
    when :delivery
      get_order
      if @order.update_attributes(order_params)
        flash[:notice] = "Delivery was successfully updated"
      else
        flash[:alert] = "Delivery wasn't updated. Check for errors."
      end
      @rendered_variable = @order
    when :payment
      get_credit_card
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

   def get_checkout_address_data
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

  def get_order
    @order = current_or_guest_user.current_order
  end

  def get_credit_card
    @credit_card = current_or_guest_user.current_order.credit_card
    unless @credit_card
      @credit_card = CreditCard.new
      @credit_card.save(validate: false)
      current_or_guest_user.current_order.update_attribute(:credit_card_id, @credit_card.id)
    end
  end

  def order_params
    params.require(:order).permit(:shipping_address_id, :billing_address_id, :credit_card_id, :user_id, :delivery_id)
  end

  def credit_card_params
    params.require(:credit_card).permit(:firstname, :lastname, :expiration_month, :expiration_year, :CVV, :number)
  end

  def checkout_address_form_params
    params.require(:checkout_address_form).permit(:billing_firstname, :billing_lastname, :billing_address,
                  :billing_zipcode, :billing_city, :billing_phone, :billing_country_id,
                  :shipping_firstname, :shipping_lastname, :shipping_address,
                  :shipping_zipcode, :shipping_city, :shipping_phone, :shipping_country_id)
  end
end
