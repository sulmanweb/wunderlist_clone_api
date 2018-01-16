require 'rails_helper'

RSpec.describe V1::Auth::RegistrationsController, type: :controller do

  describe "POST #create" do
    it "add a user" do
      user_params = FactoryBot.attributes_for(:user)
      post :create, params: user_params
      expect(response).to have_http_status(:success)
    end
  end

end
