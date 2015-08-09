class Users::OmniauthCallbacksController < ApplicationController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user
      flash[:notice] = "Signed in with facebook"
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
