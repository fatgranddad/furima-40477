class Address < ApplicationRecord
  # 郵便番号は、「123-4567」の形式に一致する必要があります（3桁の数字、ハイフン、4桁の数字）。
  validates :postal_code, presence: true, format: { with: /\A\d{3}-\d{4}\z/ }
  # 都道府県IDは整数である必要があります。
  validates :prefecture_id, presence: true, numericality: { only_integer: true }
  validates :city, presence: true
  validates :street_address, presence: true
  # 電話番号は、「09012345678」または「0312345678」の形式に一致する必要があります（10桁または11桁の数字）。
  validates :phone_number, presence: true, format: { with: /\A\d{10,11}\z/ }

  belongs_to :order
end
