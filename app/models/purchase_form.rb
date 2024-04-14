class PurchaseForm
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :postal_code, :prefecture_id, :city, :street_address, :building_name, :phone_number, :card_token

  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/ } # 郵便番号は、「123-4567」の形式
    validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" }
    validates :city
    validates :street_address
    validates :phone_number, format: { with: /\A\d{10,11}\z/ }  # 電話番号は、「09012345678」または「0312345678」の形式
    validates :card_token
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      order = Order.create!(user_id:, item_id:)
      Address.create!(
        order_id: order.id,
        postal_code:,
        prefecture_id:,
        city:,
        street_address:,
        building_name:,
        phone_number:
      )
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end
end
