class Orders::CheckoutController < ApplicationController
  #load_and_authorize_resource
  include Wicked::Wizard

  steps :address, :delivery, :payment, :confirm, :complete
  before_action :find_order

  def show
    redirect_to :back and return unless consecutive_progression_of_steps?
    case step
      when :address
        @address = CheckoutAddressForm.new
        get_checkout_address_data
        @address.populate(@billing_address, @shipping_address)
        flash[:notice]="#{current_or_guest_user.current_order.billing_address}"
      when :delivery
      when :payment
        get_credit_card
      when :confirm
      when :complete
        flash[:notice] = "Sign in or Sign up now and your order data will be saved in your account."
    end
    render_wizard
  end


  def update
    case step
      when :address
        @address = CheckoutAddressForm.new(checkout_address_form_params)
        if @address.save(@order)
          update_state
          current_user.update_settings if current_user
          redirect_to next_wizard_path and return
        else
          flash_alert
        end
      when :delivery
        @order.update_attributes(order_params) ? update_state : flash_alert
        @rendered_variable = @order
      when :payment
        get_credit_card
        @credit_card.update_attributes(credit_card_params) ? update_state : flash_alert
        @rendered_variable = @credit_card
      when :confirm
        @order.update(order_params) ? update_state : flash_alert
        @rendered_variable = @order
      end
    render_wizard @rendered_variable
  end

  private

  def flash_alert
    flash[:alert] = "#{step.capitalize} wasn't updated. Check for errors."
  end

  def flash_success
    flash[:notice] = "#{step.capitalize} was successfully updated."
  end

  def update_state
    @order.update_attribute(:state, step.to_s) unless future_step?(@order.state.to_sym)
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
    @billing_address  = current_or_guest_user.current_order.billing_address
    @shipping_address  = current_or_guest_user.current_order.shipping_address
    @billing_address ||= current_user.billing_address if current_user
    @shipping_address ||= current_user.shipping_address if current_user

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

  def find_order
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
