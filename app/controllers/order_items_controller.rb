class OrderItemsController < ApplicationController
  load_and_authorize_resource

  def create
    product_name = order_item_params.keys.select do |key|     
      "#{key}" != "quantity"
    end.first
    @product = product_name[0..-4].titleize.constantize.find(order_item_params["#{product_name}"])
    if current_or_guest_user.current_order.add_item(@product, order_item_params[:quantity])
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
