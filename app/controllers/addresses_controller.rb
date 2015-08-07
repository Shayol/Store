class AddressesController < ApplicationController

  def create
    instance_variable_set("@#{params[:address_type]}_address", Address.new(address_params))
    if instance_variable_get("@#{params[:address_type]}_address").save
      current_user.update_attributes({"#{params[:address_type]}_address_id" => instance_variable_get("@#{params[:address_type]}_address").id})
      flash[:notice] = "#{params[:address_type].capitalize} address was successfully created."
      redirect_to settings_path
    else
      flash[:alert] = "#{params[:address_type].capitalize} address wasn't created. Check for errors."
      get_billing_and_shipping_address
      render 'users/settings'
    end
  end

  def update
    instance_variable_set("@#{params[:address_type]}_address", Address.find(params[:id]))
    if instance_variable_get("@#{params[:address_type]}_address").update(address_params)
      flash[:notice] = "#{params[:address_type].capitalize}  address was successfully updated."
      redirect_to settings_path
    else
      flash[:alert] = "#{params[:address_type].capitalize} address wasn't updated. Check for errors."
      get_billing_and_shipping_address
      render 'users/settings'
    end
  end
end
