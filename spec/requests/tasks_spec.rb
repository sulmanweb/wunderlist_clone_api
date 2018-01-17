require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "POST /v1/lists/:list_id/tasks" do
    let(:session) {FactoryBot.create(:session)}
    let(:list) {FactoryBot.create(:list, user: session.user)}
    it "creates a task for logged in user" do
      headers = sign_in_test_headers(session)
      post v1_list_tasks_path(list_id: list.id), params: FactoryBot.attributes_for(:task), headers: headers
      expect(response).to have_http_status(201)
    end
    it "gives 401 if user not logged in" do
      post v1_list_tasks_path(list_id: list.id), params: FactoryBot.attributes_for(:task)
      expect(response).to have_http_status(401)
    end
    it "gives 422 if name not present" do
      headers = sign_in_test_headers(session)
      post v1_list_tasks_path(list_id: list.id), params: FactoryBot.attributes_for(:task, name: nil), headers: headers
      expect(response).to have_http_status(422)
    end
  end

  describe "GET /v1/lists/:list_id/tasks" do
    let(:session) {FactoryBot.create(:session)}
    let(:list) {FactoryBot.create(:list, user: session.user)}
    before do
      5.times do
        FactoryBot.create(:task, list: list)
      end
    end
    it "gives the list of tasks of list" do
      headers = sign_in_test_headers session
      get v1_list_tasks_path(list), headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 5
    end
    it "gives 401 if not logged in" do
      get v1_list_tasks_path(list)
      expect(response).to have_http_status(401)
    end
    it "does not allow to see other's list tasks" do
      session = FactoryBot.create(:session)
      headers = sign_in_test_headers session
      get v1_list_tasks_path(list), headers: headers
      expect(response).to have_http_status(404)
    end
  end

  describe "GET v1/lists/:list_id/tasks/:id" do
    let(:session) {FactoryBot.create(:session)}
    let(:list) {FactoryBot.create(:list, user: session.user)}
    let(:task) {FactoryBot.create(:task, list: list)}
    it "gives single task data" do
      headers = sign_in_test_headers session
      get v1_list_task_path(list_id: list.id, id: task.id), headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 5
    end
    it "gives 401 if not logged in" do
      get v1_list_task_path(list_id: list.id, id: task.id)
      expect(response).to have_http_status(401)
    end
    it "doesnot show other's tasks" do
      session = FactoryBot.create(:session)
      headers = sign_in_test_headers session
      get v1_list_task_path(list_id: list.id, id: task.id), headers: headers
      expect(response).to have_http_status(404)
    end
  end

  describe "PUT v1/lists/:list_id/tasks/:id" do
    let(:session) {FactoryBot.create(:session)}
    let(:list) {FactoryBot.create(:list, user: session.user)}
    let(:task) {FactoryBot.create(:task, list: list)}
    it "edits the specified task" do
      headers = sign_in_test_headers session
      put v1_list_task_path(list_id: list.id, id: task.id), params: {status: "done"}, headers: headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.length).to eq 5
    end
    it "gives 401 if not logged in" do
      put v1_list_task_path(list_id: list.id, id: task.id), params: {status: "done"}
      expect(response).to have_http_status(401)
    end
    it "Does not edits other person's tasks" do
      session = FactoryBot.create(:session)
      headers = sign_in_test_headers session
      put v1_list_task_path(list_id: list.id, id: task.id), params: {status: "done"}, headers: headers
      expect(response).to have_http_status(404)
    end
  end

  describe "DELETE v1/lists/:list_id/tasks/:id" do
    it "deletes the specified task" do
      session = FactoryBot.create(:session)
      list = FactoryBot.create(:list, user: session.user)
      task = FactoryBot.create(:task, list: list)
      headers = sign_in_test_headers session
      delete v1_list_task_path(list_id: list.id, id: task.id), headers: headers
      expect(response).to have_http_status(204)
    end
    it "gives 401 if not logged in" do
      list = FactoryBot.create(:list)
      task = FactoryBot.create(:task, list: list)
      delete v1_list_task_path(list_id: list.id, id: task.id)
      expect(response).to have_http_status(401)
    end
    it "Does not deletes other person's task" do
      session = FactoryBot.create(:session)
      list = FactoryBot.create(:list, user: session.user)
      task = FactoryBot.create(:task, list: list)
      session1 = FactoryBot.create(:session)
      headers = sign_in_test_headers session1
      delete v1_list_task_path(list_id: list.id, id: task.id), headers: headers
      expect(response).to have_http_status(404)
    end
  end
end
