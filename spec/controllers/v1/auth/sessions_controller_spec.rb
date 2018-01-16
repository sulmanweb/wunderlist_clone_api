require 'rails_helper'

RSpec.describe V1::Auth::SessionsController, type: :controller do

  describe "POST #create" do
    it "creates user session" do
      user = FactoryBot.create(:user)
      sign_in_params = {auth: user.email, password: user.password}
      post :create, params: sign_in_params
      expect(response).to have_http_status(:success)
    end
    it "gives error if user not found" do
      user = FactoryBot.create(:user)
      sign_in_params = {auth: 'aaaaaaa', password: user.password}
      post :create, params: sign_in_params
      expect(response).to have_http_status(422)
    end
    it "gives error if password incorrect" do
      user = FactoryBot.create(:user)
      sign_in_params = {auth: user.username, password: 'abcd1234@'}
      post :create, params: sign_in_params
      expect(response).to have_http_status(422)
    end
    it "gives error if params absent" do
      user = FactoryBot.create(:user)
      sign_in_params = {auth: user.username}
      post :create, params: sign_in_params
      expect(response).to have_http_status(422)
    end
  end

end
