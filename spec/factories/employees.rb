# == Schema Information
#
# Table name: employees
#
#  id            :bigint           not null, primary key
#  date_contract :date             not null
#  name          :string           not null
#  role          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :employee do
    name { Faker::Name.name }
    role { Faker::Company.profession  }
    date_contract { Faker::Date.between_except(from: 1.year.ago, to: 1.year.from_now, excepted: Date.today) }
  end
end
