class PurchaseForm
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :postal_code, :prefecture_id, :city, :street_address, :building_name, :phone_number, :card_token

  validates :postal_code, presence: true, format: { with: /\A\d{3}-\d{4}\z/ } # 郵便番号は、「123-4567」の形式に一致する必要があります（3桁の数字、ハイフン、4桁の数字）。
  validates :prefecture_id, presence: true, numericality: { other_than: 1, message: "can't be blank" }
  validates :city, presence: true
  validates :street_address, presence: true
  validates :phone_number, presence: true, format: { with: /\A\d{10,11}\z/ }  # 電話番号は、「09012345678」または「0312345678」の形式に一致する必要があります（10桁または11桁の数字）。
  validates :card_token, presence: true

  def save
    return false unless valid?
  
    ActiveRecord::Base.transaction do
      order = Order.create!(user_id: user_id, item_id: item_id)
      Address.create!(
        order_id: order.id,
        postal_code: postal_code,
        prefecture_id: prefecture_id,
        city: city,
        street_address: street_address,
        building_name: building_name,
        phone_number: phone_number
      )
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end
end
