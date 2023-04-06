# == Schema Information
#
# Table name: vacations
#
#  id          :bigint           not null, primary key
#  date_end    :date
#  date_init   :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  employee_id :bigint           not null
#
# Indexes
#
#  index_vacations_on_employee_id  (employee_id)
#
# Foreign Keys
#
#  fk_rails_...  (employee_id => employees.id)
#
require 'rails_helper'

RSpec.describe Vacation, type: :model do
  subject { build(:vacation) }

  it { should validate_presence_of(:date_init) }
  it { should validate_presence_of(:date_end) }
end
