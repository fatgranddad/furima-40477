class OrdersController < ApplicationController
  before_action :set_item

  def index
    gon.public_key = ENV["PAYJP_PUBLIC_KEY"]
    @purchase_form = PurchaseForm.new
  end

  def create
    @purchase_form = PurchaseForm.new(purchase_form_params)

    if @purchase_form.valid?
      charge = create_charge
      if charge&.paid
        process_payment
      else
        handle_payment_failure
      end
    else
      gon.public_key = ENV["PAYJP_PUBLIC_KEY"]
      render :index
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
    redirect_to items_path if @item.nil? || @item.sold
  end

  def purchase_form_params
    defaults = { user_id: current_user.id, item_id: @item.id }
    params.require(:purchase_form).permit(:postal_code, :prefecture_id, :city, :street_address, :building_name, :phone_number, :card_token).reverse_merge(defaults)
  end

  def create_charge
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    Payjp::Charge.create(
      amount: @item.price,
      card: purchase_form_params[:card_token],
      currency: 'jpy'
    )
  rescue Payjp::CardError => e
    @purchase_form.errors.add(:card_token, e.message)
    nil
  end

  def process_payment
    if @purchase_form.save
      update_item_sold_status  # 商品の `sold` フラグを更新
      redirect_to root_path, notice: '商品の購入が完了しました。'
    else
      render :index
    end
  end

  def handle_payment_failure
    message = "決済が完了できませんでした。カード情報を再度確認してください。"
    @purchase_form.errors.add(:card_token, message)
    render :index
  end

  def update_item_sold_status
    @item.update!(sold: true)
  end
end