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

  validates :date_init, :date_end, :employee, presence: true

  validate :validate_employee_time_contract
  validate :validate_dates_of_vacation
  validate :validate_overlapping_vacation
  validate :validate_total_times_vacation
  validate :validate_total_of_days_from_period

  def period
    date_init..date_end
  end

  def period_limit
    self.date_contract..self.date_contract.next_year
  end

  def validate_employee_time_contract
    if self.employee.date_contract.present? && self.employee.date_contract.next_year > Date.today
      return errors.add(:date, "must be within the past year")
    end
  end

  def validate_dates_of_vacation
    days = (date_init - date_end).to_i.abs

    if days > 30
      return errors.add(:date, "must not be has bigger then 30 days")
    elsif days < 10
      return errors.add(:date, "must not be has less then 10 days")
    end
  end

  def validate_overlapping_vacation
    vacations = Vacation.where(employee_id: self.employee_id)

    return if vacations.empty?

    is_overlapping = vacations.any? do |vacation|
      period.overlaps?(vacation.period)
    end
    
    errors.add(:date, "is overlapping") if is_overlapping == true
  end

  def validate_total_times_vacation
    if Vacation.where(employee_id: self.employee_id).count >= 3
      errors.add(:base, "Not be create more then 3 vacation") 
    end
  end

  def validate_total_of_days_from_period
    vacations = Vacation.where(employee_id: self.employee_id)
    
    return if vacations.empty?
    sum_date = 0

    days_new_request = (self.date_init - self.date_end).to_i.abs
    vacations.each{|v| sum_date += (v.date_init - v.date_end).to_i.abs }
    errors.add(:base, "Not be create more then 30 days") if sum_date > 30 || sum_date + days_new_request > 30
  end
end
