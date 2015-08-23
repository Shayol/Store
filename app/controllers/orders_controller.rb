class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :update]
  load_and_authorize_resource

  def show
  end

  def index
    @cart = current_or_guest_user.current_order
    @waiting_for_processing = current_or_guest_user.orders.in_queue
    @in_delivery = current_or_guest_user.orders.in_delivery
    @delivered = current_or_guest_user.orders.delivered
  end

  def empty_cart
    curent_or_guest_user.current_order.order_items.destroy_all
    current_or_guest_user.current_order.set_total_price
    flash[:notice] = "Cart is empty"
    redirect_to action: :show
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
end
