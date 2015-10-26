class Orders::CheckoutController < ApplicationController

  before_action :find_order
  include Wicked::Wizard

  steps :address, :delivery, :payment, :confirm, :complete
  before_action :step_info

  def show
    @form = CheckoutAddressForm.new({order: @order, step: step})
    @form.populate
    render_wizard
  end

  def update
    @form = CheckoutAddressForm.new(form_params.merge!({order: @order, step: step}))
    render_wizard @form
  end

  private

  def step_info
    check_if_cart_empty if step == :confirm
    check_filled_in_info unless step == :complete
    complete_step_info if step == :complete
  end

  def check_filled_in_info  ### redirect_to loop
    case step
      when :address 
        return unless @order.shipping_address && @order.billing_address
      when :delivery
        return unless @order.delivery
      when :payment
        return unless @order.credit_card
    end
    return jump_to(:address) unless @order.shipping_address && @order.billing_address
    return jump_to(:delivery) unless @order.delivery
    return jump_to(:payment) unless @order.credit_card
    flash[:info] = "Please, fill in missing info."
  end

  def check_if_cart_empty
    if @order.order_items.empty?
      flash[:alert] = "Your cart is empty. Choose some books and come back."
      return :back
    end
  end

  def complete_step_info
    @order_in_queue = current_or_guest_user.orders.in_queue.last
    flash[:info] = "Sign in or Sign up now and your order data will be saved in your account." if current_or_guest_user.guest?
  end

  def find_order
    @order = current_or_guest_user.current_order
  end

  def form_params
    params.require(:checkout_address_form).permit(:billing_firstname, :billing_lastname, :billing_address,
                  :billing_zipcode, :billing_city, :billing_phone, :billing_country,
                  :use_billing_as_shipping, :shipping_firstname, :shipping_lastname, :shipping_address,
                  :shipping_zipcode, :shipping_city, :shipping_phone, :shipping_country,
                  :card_firstname, :card_lastname, :card_expiration_month, :card_expiration_year, :card_CVV, :card_number, :delivery_id,
                  :form_completed_date)
  end
end
