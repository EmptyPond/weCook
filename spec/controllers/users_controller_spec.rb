require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "users#new" do 
    it "should allow us to visit the signup page" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
  describe "users#create" do
    it "should allow us to create a new user" do
      post :create, params: { user: { email: "darthvader@therepublic.com",password:"starwars",password_confirmation:"starwars" } }

      expect(response).to redirect_to root_path
      expect(User.last.email).to eq("darthvader@therepublic.com")
      expect(current_user.email).to eq("darthvader@therepublic.com")
    end
  end
end
