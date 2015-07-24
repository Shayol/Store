class ApplicationController < ActionController::Base
  helper_method :current_order
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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
end
