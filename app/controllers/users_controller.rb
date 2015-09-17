class UsersController < ApplicationController
  authorize_resource
  before_action :find_user


  def settings
    find_addresses
  end

  def update_address
    if type = params[:address_type]
      @user.send("#{type}") ? update_billing_or_shipping(type) : create_billing_or_shipping(type)
    end
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

  def update_billing_or_shipping(type)
    if @user.send("#{type}").update(address_params(type))
      @user.save
      flash[:notice] = "#{type.capitalize} address was successfully saved."
      return redirect_to action: :settings
    else
      find_addresses
      return render action: :settings
    end
  end

  def create_billing_or_shipping(type)
    @user.send("#{type}=", Address.new)
    if @user.send("#{type}").update(address_params(type))
      flash[:notice] = "#{type.capitalize} address was successfully saved."
      @user.save
      return redirect_to action: :settings
    else
      find_addresses
      return render action: :settings
    end
  end

  def find_addresses
    @user.billing_address ||= Address.new
    @user.shipping_address ||= Address.new
  end

  def find_user
    @user = current_user
  end

  def user_email_params
    params.require(:user).permit(:email)
  end

  def user_password_params
    params.require(:user).permit(:new_password, :old_password)
  end

  def address_params(type)
    params.require(type.to_sym).permit(:firstname, :lastname, :address, :country, :city, :phone, :zipcode)
  end
end
