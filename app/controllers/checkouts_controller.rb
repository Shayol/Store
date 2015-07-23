class CheckoutsController < ApplicationController
  def new
    @checkout = Checkout.new
  end

    def create
    @checkout = Checkout.new(checkout_params)
    @checkout.confirm_checkout

    # respond_with @registration, location: some_success_path
  end

  private

  def checkout_params
    # ...
  end
end
