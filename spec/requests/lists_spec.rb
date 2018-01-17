require 'rails_helper'

RSpec.describe "Lists", type: :request do
  describe "POST /v1/lists" do
    it "creates a list for logged in user" do
      session = FactoryBot.create(:session)
      headers = sign_in_test_headers(session)
      post v1_lists_path, params: FactoryBot.attributes_for(:list), headers: headers
      expect(response).to have_http_status(201)
    end
    it "gives 401 if user not logged in" do
      post v1_lists_path, params: FactoryBot.attributes_for(:list)
      expect(response).to have_http_status(401)
    end
    it "gives 422 if name not present" do
      session = FactoryBot.create(:session)
      headers = sign_in_test_headers(session)
      post v1_lists_path, params: {name: nil}, headers: headers
      expect(response).to have_http_status(422)
    end
  end

  describe "GET /v1/lists" do
    let(:session) {FactoryBot.create(:session)}
    before do
      5.times do
        FactoryBot.create(:list, user: session.user)
      end
    end
    it "gives the list of lists of user" do
      headers = sign_in_test_headers session
      get v1_lists_path, headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 5
    end
    it "gives 401 if not logged in" do
      get v1_lists_path
      expect(response).to have_http_status(401)
    end
  end

  describe "GET v1/lists/:id" do
    let(:session) {FactoryBot.create(:session)}
    let(:list) {FactoryBot.create(:list, user: session.user)}
    it "gives single list data" do
      headers = sign_in_test_headers session
      get v1_list_path(list), headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 4
    end
    it "gives 401 if not logged in" do
      get v1_list_path(:list)
      expect(response).to have_http_status(401)
    end
    it "doesnot show other's list" do
      session = FactoryBot.create(:session)
      headers = sign_in_test_headers session
      get v1_list_path(list), headers: headers
      expect(response).to have_http_status(404)
    end
  end

  describe "PUT v1/lists/:id" do
    let(:session) {FactoryBot.create(:session)}
    let(:list) {FactoryBot.create(:list, user: session.user)}
    it "edits the specified list item" do
      headers = sign_in_test_headers session
      put v1_list_path(list), params: {name: "Edited List"}, headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 4
    end
    it "gives 401 if not logged in" do
      put v1_list_path(list), params: {name: "Edited List"}
      expect(response).to have_http_status(401)
    end
    it "Does not edits other person's list" do
      session = FactoryBot.create(:session)
      headers = sign_in_test_headers session
      put v1_list_path(list), params: {name: "Edited List"}, headers: headers
      expect(response).to have_http_status(404)
    end
  end

  describe "DELETE v1/lists/:id" do
    it "deletes the specified list item" do
      session = FactoryBot.create(:session)
      list = FactoryBot.create(:list, user: session.user)
      headers = sign_in_test_headers session
      delete v1_list_path(list), headers: headers
      expect(response).to have_http_status(204)
    end
    it "gives 401 if not logged in" do
      list = FactoryBot.create(:list)
      delete v1_list_path(list)
      expect(response).to have_http_status(401)
    end
    it "Does not deletes other person's list" do
      session = FactoryBot.create(:session)
      list = FactoryBot.create(:list, user: session.user)
      session1 = FactoryBot.create(:session)
      headers = sign_in_test_headers session1
      delete v1_list_path(list), headers: headers
      expect(response).to have_http_status(404)
    end
  end
end
