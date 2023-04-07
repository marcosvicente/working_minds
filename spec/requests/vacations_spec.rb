require 'rails_helper'

RSpec.describe "Vacations", type: :request do
  describe "GET /index" do
    let(:employee) { create(:employee, date_contract: 1.year.ago) }
    let!(:vacation) do
      let!(:vacation) { create(:vacation, date_init: 20.days.ago, date_end: Date.today) }
      let!(:vacation) { create(:vacation, date_init: 40.days.ago, date_end: 40.days.ago) }
      let!(:vacation) { create(:vacation, date_init: 60.days.ago, date_end: 50.days.ago) }
      let!(:vacation) { create(:vacation, date_init: 80.days.ago, date_end: 70.days.ago) }
    end

    it "returns http success" do

      get "/vacations/"
        expect(response).to have_http_status(:ok)

      vacations_result = Vacation.all

      vacations_result.each_with_index do |vacation_result, index| 
        expect(response_body[index][:employee_id]).to eq(vacation_result.employee_id)
        expect(response_body[index][:date_init].to_date).to eq(vacation_result.date_init)
        expect(response_body[index][:date_end].to_date).to eq(vacation_result.date_end)
      end
    end
  end

  describe "GET /show" do
    xit "returns http success" do
      get "/vacations/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    context 'success' do
      context "first vacation" do
        let(:employee_valid) { create(:employee, date_contract: 1.year.ago) }
        let(:vacation_attr) { attributes_for(:vacation, employee_id: employee_valid.id, date_init: 20.days.ago, date_end: Date.today) }
        it 'returns http success' do
          post '/vacations',
            params: { vacation: vacation_attr }

          expect(response).to have_http_status(201)

          vacation_result = Vacation.last

          # verify attributes
          expect(vacation_attr[:employee_id]).to eq(vacation_result.employee_id)
          expect(vacation_attr[:date_init].to_date).to eq(vacation_result.date_init)
          expect(vacation_attr[:date_end].to_date).to eq(vacation_result.date_end)

          # verify response
          expect(response_body["employee_id"]).to eq(vacation_result.employee_id)
          expect(response_body["date_init"].to_date).to eq(vacation_result.date_init)
          expect(response_body["date_end"].to_date).to eq(vacation_result.date_end)
        end
      end
      context "second vacation" do
        let(:employee_valid) { create(:employee, date_contract: 1.year.ago) }
        let(:vacation_first) { create(:vacation, employee_id: employee_valid.id, date_init: 100.days.ago, date_end: 120.day.ago) }
        let(:vacation_attr) { attributes_for(:vacation, employee_id: employee_valid.id, date_init: 20.days.ago, date_end: Date.today) }

        it 'returns http success' do
          vacation_first
          post '/vacations',
            params: { vacation: vacation_attr }

          expect(Vacation.count).to be(2)

          expect(response).to have_http_status(201)

          vacation_result = Vacation.last

          # verify attributes
          expect(vacation_attr[:employee_id]).to eq(vacation_result.employee_id)
          expect(vacation_attr[:date_init].to_date).to eq(vacation_result.date_init)
          expect(vacation_attr[:date_end].to_date).to eq(vacation_result.date_end)

          # verify response
          expect(response_body["employee_id"]).to eq(vacation_result.employee_id)
          expect(response_body["date_init"].to_date).to eq(vacation_result.date_init)
          expect(response_body["date_end"].to_date).to eq(vacation_result.date_end)
        end
      end
    end

    context 'fail' do
      context 'returns http unprocessable_entity with employee time contract less 1 year' do
        let(:employee) { create(:employee, date_contract: Date.today ) }
        let(:vacation_attr_invalid) { attributes_for(:vacation, employee_id: employee.id, date_init: 20.days.ago, date_end: Date.today) }

        it do
          post '/vacations',
            params: { vacation: vacation_attr_invalid }
            
          expect(response).to have_http_status(422)
          expect(response_body).to include("Date must be within the past year")
        end
      end

      context 'returns http unprocessable_entity with dates of vacation bigger 30' do
        let(:employee) { create(:employee, date_contract: 1.year.ago) }
        let(:vacation_attr_invalid) { attributes_for(:vacation, employee_id: employee.id, date_init: 31.days.ago, date_end: Date.today) }

        it do
          post '/vacations',
            params: { vacation: vacation_attr_invalid }
            
          expect(response).to have_http_status(422)
          expect(response_body).to include("Date must not be has bigger then 30 days")
        end
      end

      context 'returns http unprocessable_entity with dates of vacation less 10' do
        let(:employee) { create(:employee, date_contract: 1.year.ago) }
        let(:vacation_attr_invalid) { attributes_for(:vacation, employee_id: employee.id, date_init: 9.days.ago, date_end: Date.today) }

        it do
          post '/vacations',
            params: { vacation: vacation_attr_invalid }
            
          expect(response).to have_http_status(422)
          expect(response_body).to include("Date must not be has less then 10 days")
        end
      end

      context 'returns http unprocessable_entity with vaction overleping' do
        let!(:employee) { create(:employee, date_contract: 1.year.ago) }
        let!(:vacation) { create(:vacation, employee: , date_init: 20.days.ago, date_end: Date.today) }
        let(:vacation_attr_invalid) { attributes_for(:vacation, employee_id: employee.id, date_init: 20.days.ago, date_end: Date.today) }

        it do
          vacation
          post '/vacations',
            params: { vacation: vacation_attr_invalid }
          
          expect(response).to have_http_status(422)
          expect(response_body).to include("Date is overlapping")
        end
      end
    end
  end

  describe "GET /update" do
    context 'success' do
      context "first vacation" do
        let(:employee) { create(:employee, date_contract: 1.year.ago) }
        let!(:vacation) { create(:vacation, date_init: 20.days.ago, date_end: Date.today) }
        let(:vacation_attr) { attributes_for(:vacation, employee_id: employee.id, date_init: 20.days.ago, date_end: Date.today) }

        it 'returns http success' do
          put "/vacations/#{vacation.id}",
            params: { vacation: vacation_attr }

          expect(response).to have_http_status(201)

          vacation_result = Vacation.last

          # verify attributes
          expect(vacation_attr[:employee_id]).to eq(vacation_result.employee_id)
          expect(vacation_attr[:date_init].to_date).to eq(vacation_result.date_init)
          expect(vacation_attr[:date_end].to_date).to eq(vacation_result.date_end)

          # verify response
          expect(response_body["employee_id"]).to eq(vacation_result.employee_id)
          expect(response_body["date_init"].to_date).to eq(vacation_result.date_init)
          expect(response_body["date_end"].to_date).to eq(vacation_result.date_end)
        end
      end
    end

    context 'fail' do
      context 'returns http unprocessable_entity with employee time contract less 1 year' do
        let(:employee) { create(:employee, date_contract: Date.today ) }
        let!(:vacation) { create(:vacation, date_init: 20.days.ago, date_end: Date.today) }

        let(:vacation_attr_invalid) { attributes_for(:vacation, employee_id: employee.id, date_init: 20.days.ago, date_end: Date.today) }

        it do
          put "/vacations/#{vacation.id}",
            params: { vacation: vacation_attr_invalid }
            
          expect(response).to have_http_status(422)
          expect(response_body).to include("Date must be within the past year")
        end
      end

      context 'returns http unprocessable_entity with dates of vacation bigger 30' do
        let(:employee) { create(:employee, date_contract: 1.year.ago) }
        let!(:vacation) { create(:vacation, employee_id: employee.id, date_init: 20.days.ago, date_end: Date.today) }

        let(:vacation_attr_invalid) { attributes_for(:vacation, employee_id: employee.id, date_init: 31.days.ago, date_end: Date.today) }

        it do
          put "/vacations/#{vacation.id}",
            params: { vacation: vacation_attr_invalid }
            
          expect(response).to have_http_status(422)
          expect(response_body).to include("Date must not be has bigger then 30 days")
        end
      end

      context 'returns http unprocessable_entity with dates of vacation less 10' do
        let(:employee) { create(:employee, date_contract: 1.year.ago) }
        let!(:vacation) { create(:vacation, employee_id: employee.id, date_init: 20.days.ago, date_end: Date.today) }
        let(:vacation_attr_invalid) { attributes_for(:vacation, employee_id: employee.id, date_init: 9.days.ago, date_end: Date.today) }

        it do
          put "/vacations/#{vacation.id}",
            params: { vacation: vacation_attr_invalid }
            
          expect(response).to have_http_status(422)
          expect(response_body).to include("Date must not be has less then 10 days")
        end
      end

      context 'returns http unprocessable_entity with vaction overleping' do
        let!(:employee) { create(:employee, date_contract: 1.year.ago) }
        let!(:vacation) { create(:vacation, employee_id: employee.id, date_init: 50.days.ago, date_end: 56.days.ago) }
        let!(:vacation) { create(:vacation, employee: , date_init: 20.days.ago, date_end: Date.today) }
        let(:vacation_attr_invalid) { attributes_for(:vacation, employee_id: employee.id, date_init: 20.days.ago, date_end: Date.today) }

        it do
          vacation
          put "/vacations/#{vacation.id}",
            params: { vacation: vacation_attr_invalid }
          
          expect(response).to have_http_status(422)
          expect(response_body).to include("Date is overlapping")
        end
      end
    end
  end

  describe "GET /delete" do
    xit "returns http success" do
      get "/vacations/delete"
      expect(response).to have_http_status(:success)
    end
  end

end
