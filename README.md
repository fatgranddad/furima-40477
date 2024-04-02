# データベース設計

このアプリケーションでは、画像のアップロードと管理にはRailsのActive Storageを使用します。Active Storageのセットアップには、`rails active_storage:install`コマンドを実行し、生成されるマイグレーションを適用することで、必要なテーブルが作成されます。商品画像は`items`テーブルと関連付けられ、画像へのアクセスはActive Storageを通じて行われます。

## 概要

- Active Storageを使用して、商品に関連する画像ファイルを管理します。
- 画像のアタッチメントとアクセスは`has_one_attached`や`has_many_attached`マクロを使用してモデルに統合されます。

以下は、本アプリケーションで使用される主要なテーブルとそのカラムのリストです。

## users テーブル

| Column                 | Type     | Options                   |
|------------------------|----------|---------------------------|
| nickname               | string   | null: false               |
| email                  | string   | null: false, default: ""  |
| encrypted_password     | string   | null: false, default: ""  |
| full_name              | string   | null: false               |
| full_name_kana         | string   | null: false               |
| birth_date             | date     | null: false               |

### Association

- has_many :items
- has_many :comments
- has_many :orders
- has_one :address

### 説明

- Deviseによるユーザー認証情報とともに、ユーザーの個人情報を格納します。メールアドレス、暗号化されたパスワード、パスワードリセットに関する情報、ログイン追跡情報、および追加のユーザー情報を含みます。

## items テーブル

| Column           | Type       | Options                       |
|------------------|------------|-------------------------------|
| name             | string     | null: false                   |
| description      | text       | null: false                   |
| category_id      | references | null: false, foreign_key: true|
| condition        | string     | null: false                   |
| shipping_payer   | string     | null: false                   |
| shipping_from    | string     | null: false                   |
| shipping_days    | string     | null: false                   |
| price            | decimal    | null: false                   |
| seller_user_id   | references | null: false, foreign_key: true|

### Association

- belongs_to :user, 出品者に対する参照。
- has_many :comments, コメントに対する参照。
- has_one :order, 注文に対する参照。

### 説明

- 商品情報を管理します。商品名、説明、カテゴリID、状態、配送料の負担者、発送元地域、発送までの日数、価格を格納します。`seller_user_id`は出品者のユーザーIDを示し、関連するユーザーテーブルへの外部キーです。

## addresses テーブル

| Column          | Type    | Options                       |
|-----------------|---------|-------------------------------|
| postal_code     | string  | null: false                   |
| prefecture      | string  | null: false                   |
| city            | string  | null: false                   |
| street_address  | string  | null: false                   |
| building_name   | string  |                               |
| phone_number    | string  | null: false                   |
| user_id         | references | null: false, foreign_key: true|

### Association

- belongs_to :user, ユーザーに対する参照。

### 説明

- ユーザーの配送先住所を管理します。郵便番号、都道府県、市区町村、番地、建物名、電話番号を格納します。`user_id`は関連するユーザーを指し、ユーザーテーブルへの外部キーです。

## orders テーブル

| Column         | Type       | Options                       |
|----------------|------------|-------------------------------|
| buyer_user_id  | references | null: false, foreign_key: true|
| item_id        | references | null: false, foreign_key: true|
| address_id     | references | null: false, foreign_key: true|
| status         | string     | null: false                   |

### Association

- belongs_to :user, ユーザー（購入者）に対する参照。
- belongs_to :item, 商品に対する参照。
- belongs_to :address, 配送先住所に対する参照。

### 説明

- 注文情報を管理します。購入者（ユーザー）ID、商品ID、配送先住所ID、および注文ステータス（例：支払い待ち、発送待ちなど）を格納します。各IDは対応するテーブルへの外部キーとして機能します。

## payments テーブル

| Column         | Type       | Options                       |
|----------------|------------|-------------------------------|
| order_id       | references | null: false, foreign_key: true|
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
| user_id    | references | null: false, foreign_key: true|
| item_id    | references | null: false, foreign_key: true|

### Association

- belongs_to :user, コメント投稿者に対する参照。
- belongs_to :item, コメントされた商品に対する参照。

### 説明

- 商品に対するコメントを管理します。コメント内容、コメントを投稿したユーザーのID、コメントが投稿された商品のIDを格納します。これにより、商品に対するフィードバックや質問をサポートします。

## categories テーブル

| Column       | Type    | Options     |
|--------------|---------|-------------|
| name         | string  | null: false |

### Association

- has_many :items, このカテゴリに属する商品に対する参照。

### 説明

- 商品カテゴリを管理します。各カテゴリにはユニークな名前があり、商品テーブルの`category_id`と関連付けられています。