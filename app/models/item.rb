class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :condition
  belongs_to :shipping_payer
  belongs_to :shipping_from
  belongs_to :shipping_days

  # プルダウンの選択が「---」の時は保存できないようにする
  with_options numericality: { other_than: 1, message: "can't be blank" } do |numerical|
    numerical.validates :category_id
    numerical.validates :condition_id
    numerical.validates :shipping_payer_id
    numerical.validates :shipping_from_id
    numerical.validates :shipping_days_id
  end

  validates :name, presence: true, length: { maximum: 40 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :price, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999 }
  validates :image, presence: true

  has_one_attached :image
  belongs_to :user
end
