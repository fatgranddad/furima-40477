FactoryBot.define do
  factory :purchase_form do
    postal_code { "123-4567" }
    prefecture_id { 13 }
    city { "Tokyo" }
    street_address { "Chiyoda 100" }
    building_name { "Empire State" }
    phone_number { "09012345678" }
    card_token { "tok_abcdefghijk00000000000000000" }
  end
end
