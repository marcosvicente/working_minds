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

  describe ".validate_employee_time_contract" do
    let!(:employee_valid) { create(:employee, date_contract: 1.year.ago) }
    let(:vacation_valid) { build(:vacation, employee: employee_valid, date_init: Date.today, date_end: 20.days.from_now) }

    let!(:employee_invalid) { create(:employee, date_contract: Date.today ) }
    let(:vacation_invalid) { build(:vacation, employee: employee_invalid, date_init: Date.today, date_end: 20.days.from_now) }

    it "should be employee biger then 1 year of contract" do
      expect(vacation_valid).to be_valid
      
      expect(vacation_valid.employee.date_contract.next_year).to be >= Date.today
    end
  
    it "should be employee less then 1 year of contract" do
      expect(vacation_invalid).to_not be_valid

      expect(vacation_invalid.errors.full_messages).to include("Date must be within the past year")
    end
  end

  describe ".validate_dates_of_vacation" do
    let!(:employee) { create(:employee, date_contract: 1.year.ago) }
    let(:vacation) { build(:vacation, employee:, date_init: Date.today, date_end: 20.days.from_now) }
    let(:vacation_35_days) { build(:vacation, employee:, date_init: Date.today, date_end: 35.days.from_now) }
    let(:vacation_5_days) { build(:vacation, employee:, date_init: Date.today, date_end: 5.days.from_now) }

    it "should be employee bigger then 30 days and less 10 of vacation" do
      expect(vacation).to be_valid
    end

    it "should be return not be bigger 30 days" do
      vacation_35_days.validate
      expect(vacation_35_days.errors.full_messages).to include("Date must not be has bigger then 30 days")
    end
  
    it "should be return not be less 10 days" do
      vacation_5_days.validate
      expect(vacation_5_days.errors.full_messages).to include("Date must not be has less then 10 days")
    end
  end

  describe ".validate_overlapping_vacation" do
      let(:employee) { create(:employee, date_contract: 1.year.ago) }
      let!(:vacation) { create(:vacation, employee:, date_init: Date.today, date_end: 20.days.ago) }
      let(:vacation2_valid) { build(:vacation, employee:, date_init: 100.days.ago, date_end: 110.days.ago) }

      let(:vacation_invalid) { build(:vacation, employee:, date_init: Date.today, date_end: 20.days.ago) }
    
    it "should be valid without overlapping" do
      vacation2_valid.validate
      expect(vacation2_valid).to be_valid
    end

    it "should be return error with overlapping" do
      vacation_invalid.validate
      expect(vacation_invalid.errors.full_messages).to include("Date is overlapping")
    end
  end

  describe ".validate_total_times_vacation" do
    let(:employee) { create(:employee, date_contract: 1.year.ago) }
    let!(:vacation) do
      create(:vacation, employee: ,date_init: 40.days.from_now, date_end: 50.days.from_now)
      create(:vacation, employee: ,date_init: 60.days.from_now, date_end: 70.days.from_now)
      create(:vacation, employee: ,date_init: 80.days.from_now, date_end: 90.days.from_now)
    end

    let(:vacation_invalid) { build(:vacation, employee:, date_init: 100.days.ago, date_end: 120.days.ago) }

    it "should be return error with more then 3 vacation" do
      vacation_invalid.validate
      expect(vacation_invalid.errors.full_messages).to include("Not be create more then 3 vacation")
    end
  end

  describe ".validate_total_of_days_from_period" do
    let(:employee) { create(:employee, date_contract: 1.year.ago) }
    let!(:vacation) { create(:vacation, employee:, date_init: 10.days.from_now, date_end: 20.days.from_now) }

    let(:vacation_invalid) { build(:vacation, employee:, date_init: 100.days.ago, date_end: 121.days.ago) }

    it "should be return error with overlapping" do

      vacation_invalid.validate
      expect(vacation_invalid.errors.full_messages).to include("Not be create more then 30 days")
    end
  end
end
