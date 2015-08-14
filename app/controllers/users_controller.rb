class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :get_settings_data


  def settings
  end

end
