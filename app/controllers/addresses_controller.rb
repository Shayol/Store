class AddressesController < ApplicationController

  def create
    instance_variable_set("@#{params[:address_type]}_address", Address.new(address_params))
    if instance_variable_get("@#{params[:address_type]}_address").save
      current_user.update_attributes({"#{params[:address_type]}_address_id" => instance_variable_get("@#{params[:address_type]}_address").id})
      flash[:notice] = "#{params[:address_type].capitalize} address was successfully created."
    else
      flash[:alert] = "#{params[:address_type].capitalize} address wasn't created. Check for errors."
    end
    redirect_to settings_path
  end

  def update
    instance_variable_set("@#{params[:address_type]}_address", Address.find(params[:id]))
    if instance_variable_get("@#{params[:address_type]}_address").update(address_params)
      flash[:notice] = "#{params[:address_type].capitalize}  address was successfully updated."
    else
      flash[:alert] = "#{params[:address_type].capitalize} address wasn't updated. Check for errors."
    end
    redirect_to settings_path
  end

  private

  def address_params
    params.require(:address).permit(:firstname, :lastname, :address, :country, :city, :phone, :zipcode)
  end

end
