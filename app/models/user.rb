class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # Deviseの認証モジュールを含む
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ニックネームは必須
  validates :nickname, presence: true

  # メールアドレスは必須であり一意である。また、@を含む形式であること
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # パスワードは必須であり、6文字以上の長さと、半角英数字混合であること
  validates :password, presence: true, length: { minimum: 6 }, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i }

  # パスワード（確認用）も作成時に必須
  validates :password_confirmation, presence: true, on: :create

  # パスワードとパスワード（確認用）の値が一致することを検証
  validate :password_match

  validates :last_name, :first_name, presence: true, format: { with: /\A[一-龠々ぁ-んァ-ンー]+\z/, message: 'は全角文字で入力してください' }
  validates :last_name_kana, :first_name_kana, presence: true, format: { with: /\A[ァ-ヶー－]+\z/, message: 'は全角カタカナで入力してください' }
  validates :birth_date, presence: true

  private

  def password_match
    return if password == password_confirmation

    # パスワードが一致しない場合はエラーメッセージを追加
    errors.add(:password_confirmation, "doesn't match Password")
  end

  has_many :items
  has_many :comments
  has_many :orders
end
