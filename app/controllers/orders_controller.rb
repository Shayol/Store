class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :update]
  before_action :find_cart, only: [:cart, :delete, :index]
  authorize_resource


  def cart
  end

  def show
  end

  def index
    @waiting_for_processing = current_or_guest_user.orders.in_queue
    @in_delivery = current_or_guest_user.orders.in_delivery
    @delivered = current_or_guest_user.orders.delivered
  end

  def delete
    @cart.order_items.destroy
    @cart.set_total_price
    flash[:notice] = "Cart is empty"
    redirect_to action: :cart
  end

  def update
    @order.order_items.each do |item|
      item.update(quantity: params["id-#{item.id}"])
    end
    @order.set_total_price
    redirect_to order_path(@order)
  end

  private

  def find_order
    @order = Order.find(params[:id])
  end

  def find_cart
     @cart = current_or_guest_user.current_order
  end
end
