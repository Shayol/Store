class OrderItemsController < ApplicationController
  #load_and_authorize_resource

  def create
    @product = order_item_params[:product_type].titleize.constantize.find(order_item_params[:product_id])
    if current_or_guest_user.current_order.add_item(@product, order_item_params[:quantity].to_i)
      flash[:notice] = "#{order_item_params[:product_type]} successfully added"
    else
      flash[:alert] = "#{order_item_params[:product_type]} wasn't added"
    end
    redirect_to cart_path
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    authorize! :destroy, @order_item
    if @order_item.destroy
      current_or_guest_user.current_order.set_total_price
      flash[:notice] = "Item deleted."
    else
      flash[:alert] = "Item wasn't deleted"
    end
    redirect_to cart_path
  end

  private
  def order_item_params
    params.require(:order_item).permit(:product_type, :product_id, :quantity)
  end
end
