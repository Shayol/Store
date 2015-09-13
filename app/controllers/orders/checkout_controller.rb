class Orders::CheckoutController < ApplicationController
  #load_and_authorize_resource
  before_action :find_order
  include Wicked::Wizard

  steps :address, :delivery, :payment, :confirm, :complete
  before_action :check_filled_in_info, only: :show
  before_action :check_if_cart_empty, only: :update
  before_action :complete_step_info, only: :show

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

  def flash_wrong_step
    flash[:info] = "Please, fill in missing info."
  end


  def check_filled_in_info
    unless step == :complete
       jump_to(:address) unless @order.shipping_address && @order.billing_address && step != :address
       jump_to(:delivery) unless @order.delivery && step != :delivery
       jump_to(:payment) unless @order.credit_card && step != :payment
    end
  end

  def check_if_cart_empty
    if (step == :confirm) && @order.order_items.empty?
      flash[:alert] = "Your cart is empty. Choose some books and come back."
      redirect_to :back and return
    end
  end

  def complete_step_info
    if step == :complete
      @order_in_queue = current_or_guest_user.orders.in_queue.last
      flash[:info] = "Sign in or Sign up now and your order data will be saved in your account." if current_or_guest_user.guest?
    end
  end

  def find_order
    @order = current_or_guest_user.current_order
  end

  def form_params
    params.require(:checkout_address_form).permit(:billing_firstname, :billing_lastname, :billing_address,
                  :billing_zipcode, :billing_city, :billing_phone, :billing_country_id,
                  :use_billing_as_shipping, :shipping_firstname, :shipping_lastname, :shipping_address,
                  :shipping_zipcode, :shipping_city, :shipping_phone, :shipping_country_id,
                  :card_firstname, :card_lastname, :card_expiration_month, :card_expiration_year, :card_CVV, :card_number, :delivery_id,
                  :form_completed_date)
  end
end
