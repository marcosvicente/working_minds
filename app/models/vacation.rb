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

  validate :validate_employee_time_contract
  validate :validate_dates_of_vacation
  validate :validate_overlapping_vacation

  def period
    date_init..date_end
  end

  def validate_employee_time_contract
    if self.employee.date_contract.present? && self.employee.date_contract.next_year > Date.today
      return errors.add(:date, "must be within the past year")
    end
  end

  def validate_dates_of_vacation
    date_total = (date_init - date_end).to_i.abs

    if date_total > 30
      return errors.add(:date, "must not be has bigger then 30 days")
    elsif date_total < 10
      return errors.add(:date, "must not be has less then 10 days")
    end
  end

  def validate_overlapping_vacation
    vacation = Vacation.where(employee_id: self.employee_id)

    return if vacation.empty?

    is_overlapping = vacation.any? do |vacation|
      period.overlaps?(vacation.period)
    end
    
    errors.add(:date, "is overlapping") if is_overlapping == true
  end
end
