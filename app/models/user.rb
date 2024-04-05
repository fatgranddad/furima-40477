class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # Deviseの認証モジュールを含む
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ニックネームは必須
  validates :nickname, presence: true

  # メールアドレスは必須であり一意である。また、@を含む形式であること
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  # パスワードは必須であり、6文字以上の長さと、半角英数字混合であること
  validates :password, presence: true
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i }, allow_blank: true

  # パスワード（確認用）も作成時に必須
  validates :password_confirmation, presence: true, on: :create

  validates :last_name, :first_name, presence: true
  validates :last_name, :first_name, format: { with: /\A[一-龠々ぁ-んァ-ンー]+\z/, message: 'must be entered in full-width characters' }, allow_blank: true

  validates :last_name_kana, :first_name_kana, presence: true
  validates :last_name_kana, :first_name_kana, format: { with: /\A[ァ-ヶー－]+\z/, message: 'must be entered in full-width katakana characters' }, allow_blank: true

  validates :birth_date, presence: true

  has_many :items
  has_many :comments
  has_many :orders
end
