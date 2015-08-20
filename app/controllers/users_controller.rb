class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :get_settings_data
  before_action :find_user


  def settings
  end

  def update_password
    if @user.valid_password?(user_password_params[:old_password])
      if @user.update(password: user_password_params[:new_password])
        sign_in @user, :bypass => true
        redirect_to settings_path, notice: "Password changed."
      else
        flash[:alert] = "Password wasn't updated. Check for errors."
        render "settings"
      end
    else
    flash[:alert] = "Wrong old password ."
    render "settings"
    end
  end

     def update_email
      if @user.update!(user_email_params)
        flash[:success] = "Email changed."
        redirect_to settings_path
      else
        flash[:alert] = "Email wasn't updated. Check for errors."
        render "settings"
      end
  end

  private

  def find_user
    @user = current_user
  end

  def user_email_params
    params.require(:user).permit(:email)
  end

  def user_password_params
    params.require(:user).permit(:new_password, :old_password)
  end

end
