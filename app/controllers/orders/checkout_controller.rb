class Orders::CheckoutController < ApplicationController
  #load_and_authorize_resource
  before_action :find_order
  include Wicked::Wizard

  steps :address, :type_of_delivery, :payment, :confirm, :complete


  def show
    redirect_to :back and return unless consecutive_progression_of_steps?
    case step
      when :address
        @address = CheckoutAddressForm.new
        get_checkout_address_data
        @address.populate(@order.billing_address, @order.shipping_address)
      when :payment
        @credit_card = @order.credit_card || CreditCard.new
      when :complete
        @order_in_queue = current_or_guest_user.orders.in_queue.last
        flash[:info] = "Sign in or Sign up now and your order data will be saved in your account."
    end
    render_wizard
  end


  def update
    case step
      when :address
        address ? (redirect_to next_wizard_path and return) : (render_wizard and return)
      when :type_of_delivery
        @order.update(order_params) ? update_state : flash_alert
      when :payment
        return render_wizard payment
      when :confirm
        redirect_to :back and return unless confirm
      end
     render_wizard @order
  end

  private

  def flash_alert
    flash[:alert] = "#{step.capitalize} wasn't updated. Check for errors."
  end

  def flash_success
    flash[:notice] = "#{step.capitalize} was successfully updated."
  end

  def address
    @address = CheckoutAddressForm.new(checkout_address_form_params)
      if @address.save(@order)
        update_state
        true
      else
        flash_alert
       false
      end
  end

  def payment
    @credit_card = @order.credit_card ||= CreditCard.new
    @order.credit_card.update(credit_card_params) ? update_state : flash_alert
    @credit_card
  end

  def confirm
    if cart_not_empty?
      @order.update(order_params)
      update_state
      true
    else
      flash[:alert] = "Your cart is empty. Choose some books and come back."
      false
    end
  end

  def update_state
    @order.save #  whyyyy????
    unless future_step?(@order.state.to_sym)
      @order.update_attribute(:state, step.to_s)
        #@order.send(step.to_s.concat("_event!"))
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

  def cart_not_empty?
    @order.order_items.any?
  end

  def get_checkout_address_data
    if !current_or_guest_user.guest?
      @order.billing_address ||= current_user.billing_address.dup if current_user.billing_address
      @order.shipping_address ||= current_user.shipping_address.dup if current_user.shipping_address
    end
    unless @order.billing_address
      @order.billing_address = Address.new
      @order.billing_address.save(validate: false)
     end
    unless @order.shipping_address
      @order.shipping_address = Address.new
      @order.shipping_address.save(validate: false)
    end
    @order.save## why need this?!!!!
  end

  def find_order
    @order = current_or_guest_user.current_order
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
