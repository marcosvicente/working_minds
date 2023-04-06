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
class Vacation < ApplicationRecord
  belongs_to :employee

  validates :date_init, :date_end, presence: true

end
