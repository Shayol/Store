class Orders::CheckoutController < ApplicationController
  #load_and_authorize_resource
  include Wicked::Wizard

  steps :address, :type_of_delivery, :payment, :confirm, :complete


  def show
    @order = current_or_guest_user.current_order
    redirect_to :back and return unless consecutive_progression_of_steps?
    case step
      when :address
        @address = CheckoutAddressForm.new
        get_checkout_address_data
        @address.populate(@order.billing_address, @order.shipping_address)
      when :type_of_delivery
      when :payment
        @credit_card = @order.credit_card || CreditCard.new
      when :confirm
      when :complete
        @order_in_queue = current_or_guest_user.orders.in_queue.last
        flash[:info] = "Sign in or Sign up now and your order data will be saved in your account."
    end
    render_wizard
  end


  def update
    @order = current_or_guest_user.current_order
    case step
      when :address
        @address = CheckoutAddressForm.new(checkout_address_form_params)
        if @address.save(@order)
          update_state
          redirect_to next_wizard_path and return
        else
          flash_alert
        end
      when :type_of_delivery
        @order.update(order_params) ? update_state : flash_alert
        @rendered_variable = @order
      when :payment
        @credit_card = @order.credit_card ||= CreditCard.new
        @order.credit_card.update(credit_card_params) ? update_state : flash_alert
        @rendered_variable = @credit_card
      when :confirm
        @order.update(order_params) ? update_state : flash_alert
        @rendered_variable = @order
      end
    render_wizard @rendered_variable # refactor this
  end

  private

  def flash_alert
    flash[:alert] = "#{step.capitalize} wasn't updated. Check for errors."
  end

  def flash_success
    flash[:notice] = "#{step.capitalize} was successfully updated."
  end

  def update_state
    @order.save #  whyyyy????
    unless future_step?(@order.state.to_sym)
      #@order.update_attribute(:state, step.to_s)
      @order.send(step.to_s.concat("_event!"))
    end
    flash_success
  end

  def consecutive_progression_of_steps?
    if (past_step?(@order.state.to_sym) && !previous_step?(@order.state.to_sym))
      flash[:alert]="Fill in previous steps in checkout, please."
      false
    else
      true
    end
  end

  def get_checkout_address_data
    if current_user && current_user.billing_address
      @order.billing_address ||= current_user.billing_address.dup
      @order.shipping_address ||= current_user.shipping_address.dup
      @order.save ## check if can leave it out!!!!
   end
    unless @order.billing_address
      @order.billing_address = Address.new
      @order.billing_address.save(validate: false)
     end
    unless @order.shipping_address
      @order.shipping_address = Address.new
      @order.shipping_address.save(validate: false)
    end
  end

  def order_params
    params.require(:order).permit(:shipping_address_id, :billing_address_id, :credit_card_id, :user_id, :delivery_id, :state, :completed_date)
  end

  def credit_card_params
    params.require(:credit_card).permit(:firstname, :lastname, :expiration_month, :expiration_year, :CVV, :number)
  end

  def checkout_address_form_params
    params.require(:checkout_address_form).permit(:billing_firstname, :billing_lastname, :billing_address,
                  :billing_zipcode, :billing_city, :billing_phone, :billing_country_id,
                  :use_billing_as_shipping, :shipping_firstname, :shipping_lastname, :shipping_address,
                  :shipping_zipcode, :shipping_city, :shipping_phone, :shipping_country_id)
  end
end
