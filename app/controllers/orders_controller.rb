class OrdersController < ApplicationController
  before_action :set_item

  def index
    @order = Order.new
  end

  private

  def set_item
    @item = Item.find_by(id: params[:item_id])
    if @item.nil?
      redirect_to items_path, alert: "指定された商品が見つかりません。"
    end
  end
end
