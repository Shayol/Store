class Orders::CheckoutController < ApplicationController
  #load_and_authorize_resource
  before_action :find_order
  include Wicked::Wizard

  steps :address, :delivery, :payment, :confirm, :complete
  before_action :check_filled_in_info


  def show
    case step
      when :address
        @address = CheckoutAddressForm.new
        get_checkout_address_data
        @address.populate(@order.billing_address, @order.shipping_address)
      when :payment
        @credit_card = @order.credit_card || CreditCard.new
      when :complete
        @order_in_queue = current_or_guest_user.orders.in_queue.last
        flash[:info] = "Sign in or Sign up now and your order data will be saved in your account." if current_or_guest_user.guest?
    end
    render_wizard
  end


  def update
    case step
      when :address
        address ? (redirect_to next_wizard_path and return) : (render_wizard and return)
      when :delivery
        delivery
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

  def flash_wrong_step
    flash[:info] = "Please, fill in missing info."
  end

  def address
    @address = CheckoutAddressForm.new(checkout_address_form_params)
      if @address.save(@order)
        true
      else
        flash_alert
        false
      end
  end

  def delivery
    if @order.update!(order_params)
      @order.set_total_price
      flash_success
     else
      flash_alert
    end
  end

  def payment
    @credit_card = @order.credit_card ||= CreditCard.new
    @order.credit_card.update(credit_card_params) ? @order.save : flash_alert
    @credit_card
  end

  def confirm
    if cart_not_empty?
      @order.update(order_params)
      @order.confirm_event!
      true
    else
      flash[:alert] = "Your cart is empty. Choose some books and come back."
      false
    end
  end

  def check_filled_in_info
    case step
      when :delivery
         unless @order.shipping_address && @order.billing_address
          flash_wrong_step
          jump_to(:address)
         end
      when :payment
        unless @order.shipping_address && @order.billing_address
          flash_wrong_step
          jump_to(:address)
        end
        unless @order.delivery
          flash_wrong_step
          jump_to(:delivery)
        end
      when :confirm
        unless @order.shipping_address && @order.billing_address
          flash_wrong_step
          jump_to(:address)
        end
        unless @order.delivery
          flash_wrong_step
          jump_to(:delivery)
        end
        unless @order.credit_card
          flash_wrong_step
          jump_to(:payment)
        end
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
