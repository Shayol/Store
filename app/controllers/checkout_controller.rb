class CheckoutController < ApplicationController

  include Wicked::Wizard

  steps :billing_and_shipping_address, :delivery, :payment, :confirm, :complete

  def show
    @order = current_order
    @billing_address = current_user.billing_address || Address.create
    render_wizard
  end


  def update
    @order = current_order
    params[:order][:state] = 'in_queue' if step == steps[-2]
    case step
    when :billing_and_shipping_address
      @billing_address = Address.update_attributes(params[:billing_address])
      current_order.billing_address = @billing_address
    when :delivery
    when :payment

    end
    render_wizard
  end

  def create

  end
  # def new
  #   @checkout = Checkout.new
  # end

  #   def create
  #   @checkout = Checkout.new(checkout_params)
  #   @checkout.confirm_checkout

  #   # respond_with @registration, location: some_success_path
  # end

  private

  def checkout_params
    # ...
  end
end
