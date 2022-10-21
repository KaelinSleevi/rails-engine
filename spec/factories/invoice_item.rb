FactoryBot.define do
 factory :invoice_item do
  quantity { Faker::Number.within(range: 1..999999) }
  unit_price { Faker::Number.within(range: 1..999999) }
  association :item, factory: :item
  association :invoice, factory: :invoice
 end
end