class UsersController < ApplicationController
  before_action :get_billing_and_shipping_address

  def settings
  end

end
