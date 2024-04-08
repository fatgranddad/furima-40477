FactoryBot.define do
  factory :item do
    name                 { "商品名" }
    description          { "商品の説明" }
    category_id          { 2 }
    condition_id         { 2 }
    shipping_payer_id    { 2 }
    shipping_from_id     { 2 }
    shipping_days_id     { 2 }
    price                { Faker::Number.between(from: 300, to: 9999999) }
    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('spec/fixtures/test_image.png'), filename: 'test_image.png', content_type: 'image/png')
    end
  end
end
