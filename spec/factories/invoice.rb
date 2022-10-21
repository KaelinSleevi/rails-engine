FactoryBot.define do
 factory :invoice do
  status { Faker::Number.within(range: 0..2) }
  association :merchant, factory: :merchant
  association :customer, factory: :customer
 end

end