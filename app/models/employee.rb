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
class Employee < ApplicationRecord
  validates :name, :role, :date_contract, presence: true
end
