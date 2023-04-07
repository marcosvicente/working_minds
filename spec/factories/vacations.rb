FactoryBot.define do
  factory :vacation do
    employee  { nil }
    date_init { Faker::Date.between_except(from: 1.month.ago, to: 1.month.from_now, excepted: Date.today) }
    date_end  { Faker::Date.between_except(from: 1.month.ago, to: 1.month.from_now, excepted: Date.today) }
  end
end
