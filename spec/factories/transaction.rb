FactoryBot.define do
 factory :transaction do
  result { Faker::Lorem.sentence }
  credit_card_number{ Faker::Number.within(range: 1..999999) }
  credit_card_expiration_date{ Faker::Number.within(range: 1000..9999) }
  association :invoice, factory: :invoice
 end
end