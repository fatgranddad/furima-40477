class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname, presence: true

  validates :last_name, :first_name, presence: true
  validates :last_name, :first_name, format: { with: /\A[一-龠々ぁ-んァ-ンー]+\z/, message: 'must be entered in full-width characters' }, allow_blank: true

  validates :last_name_kana, :first_name_kana, presence: true
  validates :last_name_kana, :first_name_kana, format: { with: /\A[ァ-ヶー－]+\z/, message: 'must be entered in full-width katakana characters' }, allow_blank: true

  validates :birth_date, presence: true

  has_many :items
  has_many :comments
  has_many :orders
end
