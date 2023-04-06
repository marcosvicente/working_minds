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
require 'rails_helper'

RSpec.describe Employee, type: :model do
  subject { create(:employee) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:role) }
  it { should validate_presence_of(:date_contract) }

end
