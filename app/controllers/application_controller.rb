class ApplicationController < ActionController::Base
  helper_method :current_order
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
   redirect_to main_app.root_path, :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    if resource.class == Admin
      rails_admin_path
    else
      stored_location_for(resource) || root_path
    end
  end

  def current_order
    # current_user ||= User.new
    order = current_user.orders.in_progress.first || current_user.orders.create
    order
  end

  def get_billing_and_shipping_address
    @billing_address ||= current_user.billing_address || Address.new
    @shipping_address ||= current_user.shipping_address || Address.new
  end

  def get_checkout_data
    unless current_order.billing_address || current_user.billing_address
      @billing_address = Address.new
      @billing_address.save(validate: false)
      current_order.update_attribute(:billing_address_id, @billing_address.id)
    end

    unless current_order.shipping_address || current_user.shipping_address
      @shipping_address = Address.new
      @shipping_address.save(validate: false)
      current_order.update_attribute(:shipping_address_id, @shipping_address.id)
    end

    unless current_order.credit_card
      @credit_card = CreditCard.new
      @credit_card.save(validate: false)
      current_order.update_attribute(:credit_card_id, @credit_card.id)
    end

    @billing_address  = current_order.billing_address || current_user.billing_address
    @shipping_address  = current_order.shipping_address || current_user.shipping_address
    @credit_card = current_order.credit_card
  end

  def address_params
    params.require(:address).permit(:firstname, :lastname, :address, :country_id, :city, :phone, :zipcode)
  end

end
