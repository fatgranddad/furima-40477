# データベース設計

このアプリケーションでは、画像のアップロードと管理にはRailsのActive Storageを使用します。
このアプリケーションでは、静的なデータ（例：商品カテゴリー、都道府県情報、商品の状態）の管理にActive Hashを使用します。`category_id`, `condition_id`, `shipping_payer_id`, `shipping_from_id`, `shipping_days_id` などのカラムは、Active Hashを使用して管理されます。

以下は、本アプリケーションで使用される主要なテーブルとそのカラムのリストです。

## users テーブル

| Column                  | Type   | Options                        |
|-------------------------|--------|--------------------------------|
| nickname                | string | null: false                    |
| email                   | string | null: false, unique: true      |
| encrypted_password      | string | null: false                    |
| last_name               | string | null: false                    |
| first_name              | string | null: false                    |
| last_name_kana          | string | null: false                    |
| first_name_kana         | string | null: false                    |
| birth_date              | date   | null: false                    |

### Association

- has_many :items
- has_many :comments
- has_many :orders

### 説明

- `nickname`: ユーザーがアプリケーション内で使用するユーザー名です。
- `email`: ユーザーのメールアドレスで、ログインに使用されます。各メールアドレスは一意でなければならないという制約があります。
- `encrypted_password`: Deviseにより暗号化されたユーザーのパスワードです。
- `last_name`: ユーザーの姓です。
- `first_name`: ユーザーの名です。
- `last_name_kana`: ユーザーの姓のフリガナです。
- `first_name_kana`: ユーザーの名のフリガナです。
- `birth_date`: ユーザーの生年月日です。

## items テーブル

| Column            | Type       | Options                        |
|-------------------|------------|--------------------------------|
| name              | string     | null: false                    |
| description       | text       | null: false                    |
| category_id       | integer    | null: false, foreign_key: true |
| condition_id      | integer    | null: false                    |
| shipping_payer_id | integer    | null: false                    |
| shipping_from_id  | integer    | null: false                    |
| shipping_days_id  | integer    | null: false                    |
| price             | integer    | null: false                    |
| user              | references | null: false, foreign_key: true |

### Association

- belongs_to :user, 出品者に対する参照。
- has_many :comments, コメントに対する参照。
- has_one :order, 注文に対する参照。

### 説明

- 商品情報を管理します。商品名、説明、カテゴリID、状態、配送料の負担者、発送元地域、発送までの日数、価格を格納します。
- `category_id`, `condition_id`, `shipping_payer_id`, `shipping_from_id`, `shipping_days_id` はactive_hashを使用して管理します。これらのカラムはid値（数値）を保存し、別途active_hashで定義されたモデルから具体的なデータを参照します。
- `user` は出品者のユーザーIDを示し、関連するユーザーテーブルへの外部キーです。

## addresses テーブル

| Column         | Type       | Options                        |
|----------------|------------|--------------------------------|
| postal_code    | string     | null: false                    |
| prefecture_id  | integer    | null: false                    |
| city           | string     | null: false                    |
| street_address | string     | null: false                    |
| building_name  | string     |                                |
| phone_number   | string     | null: false                    |
| order          | references | null: false, foreign_key: true |

### Association

- belongs_to :order

### 説明

- `postal_code`: 郵便番号。文字列型を使用します。
- `prefecture_id`: 都道府県。active_hashを使用し、integer型でid値を保存します。
- `city`: 市区町村。文字列型を使用します。
- `street_address`: 番地。文字列型を使用します。
- `building_name`: 建物名。任意で入力可能なため、null制約はありません。
- `phone_number`: 電話番号。文字列型を使用します。
- `order`: 注文の外部キー。`addresses` テーブルが特定の注文に対する配送先住所を提供するために使用します。

## orders テーブル

| Column     | Type       | Options                        |
|------------|------------|--------------------------------|
| user       | references | null: false, foreign_key: true |
| item       | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :item
- has_one :address

## payments テーブル

| Column         | Type       | Options                       |
|----------------|------------|-------------------------------|
| order          | references | null: false, foreign_key: true|
| amount         | decimal    | null: false                   |
| status         | string     | null: false                   |
| payment_method | string     | null: false                   |

### Association

- belongs_to :order, 注文に対する参照。

### 説明

- 支払い詳細を管理します。注文ID、支払い金額、支払い状態、および支払い方法を格納します。支払い状態には例えば「支払い済み」や「未支払い」などの状態があります。`payment_method`は今回はクレジットカードのみを想定しています。

## comments テーブル

| Column     | Type       | Options                       |
|------------|------------|-------------------------------|
| content    | text       | null: false                   |
| user       | references | null: false, foreign_key: true|
| item       | references | null: false, foreign_key: true|

### Association

- belongs_to :user, コメント投稿者に対する参照。
- belongs_to :item, コメントされた商品に対する参照。

### 説明

- 商品に対するコメントを管理します。コメント内容、コメントを投稿したユーザーのID、コメントが投稿された商品のIDを格納します。これにより、商品に対するフィードバックや質問をサポートします。