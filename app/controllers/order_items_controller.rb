class OrderItemsController < ApplicationController
  load_and_authorize_resource

  def destroy
    @order_item.destroy
    current_or_guest_user.current_order.set_total_price
    redirect_to order_path(current_or_guest_user.current_order)
  end
end
