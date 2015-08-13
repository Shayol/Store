class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :update]
  def show
    @order_items = @order.order_items
  end

  def index
    @orders = current_or_guest_user.orders.all
  end

  def empty_cart
    curent_or_guest_user.current_order.order_items.delete
    current__or_guest_user.current_order.set_total_price
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
