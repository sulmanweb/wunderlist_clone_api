require 'rails_helper'

RSpec.describe "Auths", type: :request do
  describe "POST v1/auth/signup" do
    it "creates a user" do
      signup_attributes = FactoryBot.attributes_for(:user)

      post v1_auth_sign_up_path, params: signup_attributes

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)

      expect(json.length).to eq 5
    end
    it "gives 422 if data incorrect" do
      signup_attributes = FactoryBot.attributes_for(:user, password: "")

      post v1_auth_sign_up_path, params: signup_attributes

      expect(response).to have_http_status(422)
    end
    it "gives 422 if data incomplete" do
      signup_attributes = FactoryBot.attributes_for(:user, password: nil)

      post v1_auth_sign_up_path, params: signup_attributes

      expect(response).to have_http_status(422)
    end
    it "gives 422 on duplication" do
      FactoryBot.create(:user, username: "sulmanweb")
      signup_attributes = FactoryBot.attributes_for(:user, username: "sulmanweb")

      post v1_auth_sign_up_path, params: signup_attributes

      expect(response).to have_http_status(422)
    end
  end

  describe "POST v1/auth/signin" do
    let(:user) {FactoryBot.create(:user)}
    it "creates the session for the user" do
      sign_in_params = {auth: user.email, password: user.password}
      post v1_auth_sign_in_path, params: sign_in_params
      expect(response).to have_http_status(:success)
      expect(response.headers).to include('sid')
      expect(response.headers).to include('utoken')
    end
    it "gives 422 if username, email or password wrong" do
      sign_in_params = {auth: 'aaaaaaaa', password: user.password}
      post v1_auth_sign_in_path, params: sign_in_params
      expect(response).to have_http_status(422)
      sign_in_params = {auth: user.email, password: 'abcdefghijk'}
      post v1_auth_sign_in_path, params: sign_in_params
      expect(response).to have_http_status(422)
    end
    it "gives 422 if data incomplete" do
      sign_in_params = {auth: user.email}

      post v1_auth_sign_in_path, params: sign_in_params

      expect(response).to have_http_status(422)
    end
  end
end
