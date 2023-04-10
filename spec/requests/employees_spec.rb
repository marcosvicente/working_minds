require 'rails_helper'

RSpec.describe "Employees", type: :request do
  describe "GET /index" do
    let(:employee) { create_list(:employee, 10) }

    it "returns http success" do

      get "/employees/"
      expect(response).to have_http_status(:ok)

      employees_result = Vacation.all

      employees_result.each_with_index do |employee_result, index| 
        expect(response_body[index][" date_contract"]).to eq(employee_result.date_contract)
        expect(response_body[index][" name"].to_date).to  eq(employee_result.name)
        expect(response_body[index][" role"].to_date).to  eq(employee_result.role)
      end
    end
  end
end
