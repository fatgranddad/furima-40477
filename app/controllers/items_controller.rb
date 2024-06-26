class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :redirect_unless_author, only: [:edit, :update, :destroy]
  before_action :redirect_if_sold, only: [:edit, :update, :destroy]

  def index
    @items = Item.includes(:order).order('created_at DESC')
  end

  def show
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: '商品が正常に出品されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item), notice: '商品情報が更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to root_path, notice: '商品が正常に削除されました。'
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :image, :description, :category_id, :condition_id, :shipping_payer_id, :shipping_from_id,
                                 :shipping_days_id, :price).merge(user_id: current_user.id)
  end

  def redirect_unless_author
    redirect_to root_path unless current_user.id == @item.user_id
  end

  def redirect_if_sold
    redirect_to root_path, alert: '売却済みの商品は編集または削除できません。' if @item.order.present?
  end
end
