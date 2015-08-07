class OrdersController < ApplicationController
  before_action :find_order, only: :show
  def show
    @order_items = current_order.order_items
  end

  def index
    @orders = current_user.orders.all
  end

  def empty_cart
    current_order.order_items.delete
    current_order.set_total_price
    flash[:notice] = "Cart is empty"
    redirect_to action: :show
  end

  private

  def find_order
    @order = Order.find(params[:id])
  end
end
