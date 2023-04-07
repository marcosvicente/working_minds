require 'rails_helper'

RSpec.describe "Vacations", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/vacations/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/vacations/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/vacations/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/vacations/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /delete" do
    it "returns http success" do
      get "/vacations/delete"
      expect(response).to have_http_status(:success)
    end
  end

end
