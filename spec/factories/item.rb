FactoryBot.define do
 factory :item do
  name { Faker::Name.name }
  description { Faker::Lorem.sentence }
  unit_price { Faker::Number.within(range: 1..999999) }
  association :merchant, factory: :merchant
 end
end