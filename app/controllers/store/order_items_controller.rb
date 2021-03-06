class Store::OrderItemsController < ApplicationController
  def delete
    item = Store::OrderItem.find(params[:id])
    order = item.order
    item.delete
    order.update_total_price
    flash[:notice] = "已刪除：#{item.product.title}"
    redirect_to store_order_path(order)
  end
end
