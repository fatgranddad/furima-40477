require 'rails_helper'

RSpec.describe PurchaseForm, type: :model do
  describe '商品購入' do
    before do
      # ActiveRecord::Base.connection.reconnect!
      # Rails.logger.level = :debug
      user = FactoryBot.create(:user)
      item = FactoryBot.create(:item)
      # puts user.inspect # この行を追加して出力を確認
      # puts item.inspect # この行を追加して出力を確認
      @purchase_form = FactoryBot.build(:purchase_form, user_id: user.id, item_id: item.id)
    end

    context '商品購入がうまくいくとき' do
      it 'すべての値が正しく入力されていれば購入できる' do
        expect(@purchase_form).to be_valid
      end

      it '建物名は任意であること' do
        @purchase_form.building_name = ''
        expect(@purchase_form).to be_valid
      end
    end

    context '商品購入がうまくいかないとき' do
      it '郵便番号が空だと購入できない' do
        @purchase_form.postal_code = ''
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("Postal code can't be blank")
      end

      it '郵便番号は、「3桁ハイフン4桁」の半角文字列のみで入力しなければ、購入できない' do
        @purchase_form.postal_code = '1234567'
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include('Postal code is invalid')
      end

      it '都道府県が必須であること' do
        @purchase_form.prefecture_id = 1
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("Prefecture can't be blank")
      end

      it '市区町村が空だと購入できない' do
        @purchase_form.city = ''
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("City can't be blank")
      end

      it '番地が空だと購入できない' do
        @purchase_form.street_address = ''
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("Street address can't be blank")
      end

      it '電話番号が空だと購入できない' do
        @purchase_form.phone_number = ''
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("Phone number can't be blank")
      end

      it '電話番号は、10桁以上11桁以内の半角数値のみ保存可能なこと' do
        @purchase_form.phone_number = '12345'
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include('Phone number is invalid')
        @purchase_form.phone_number = '123456789012'
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include('Phone number is invalid')
      end

      it 'カードトークンが空だと購入できない' do
        @purchase_form.card_token = ''
        @purchase_form.valid?
        expect(@purchase_form.errors.full_messages).to include("Card token can't be blank")
      end
    end
  end
end