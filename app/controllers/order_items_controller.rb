class OrderItemsController < ApplicationController
  load_and_authorize_resource

  def create
    if current_or_guest_user.current_order.add_item(order_item_params[:book_id].to_i, order_item_params[:quantity].to_i)
      flash[:notice] = "Book successfully added"
    else
      flash[:alert] = "Book wasn't added"
    end
    redirect_to cart_path
  end

  def destroy
    @order_item.destroy
    current_or_guest_user.current_order.set_total_price
    redirect_to order_path(current_or_guest_user.current_order)
  end

  private
  def order_item_params
    params.require(:order_item).permit(:quantity, :book_id)
  end
end
