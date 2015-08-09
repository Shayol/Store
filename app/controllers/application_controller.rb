class ApplicationController < ActionController::Base
  helper_method :current_order
  helper_method :current_or_guest_user
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
    order = current_or_guest_user.orders.in_progress.first || current_or_guest_user.orders.create
    order
  end

  def get_billing_and_shipping_address
    @billing_address ||= currents_user.billing_address || Address.new
    @shipping_address ||= current_user.shipping_address || Address.new
  end

  def get_checkout_data
    unless current_order.billing_address || current_or_guest_user.billing_address
      @billing_address = Address.new
      @billing_address.save(validate: false)
      current_order.update_attribute(:billing_address_id, @billing_address.id)
    end

    unless current_order.shipping_address || current_or_guest_user.shipping_address
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

   # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        guest_user(with_retry = false).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user(with_retry = true)
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user if with_retry
  end

  private

  # called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    guest_order = guest_user.orders.in_progress.first
    current_user_order = current_user.orders.in_progress.first
      if current_user_order.order_items.empty?
        guest_order.order_items.each do |order_item|
          order_item.order_id = current_user_order.id
          order_item.save!
        end
      else
        current_user_order.merge guest_order
      end
  end

  def create_guest_user
    u = User.create(:firstname => "guest", :email => "guest_#{Time.now.to_i}#{rand(100)}@example.com", :confirmed_at => Time.now.utc)
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end


  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:firstname, :lastname, :email, :password, :password_confirmation) }
    end

end
