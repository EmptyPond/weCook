require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe "static_pages#index" do
    it "should allow initial access to landing page" do 
      get :index
      expect(response).to have_http_status(:success)
    end 
  end
  describe "static_pages#my_page" do
    it "should let you see my_page if you are logged in" do
      kitchen = FactoryGirl.create(:kitchen)
      login_user(kitchen.user.last)
      get :my_page, params: { id: kitchen.user.last.id }

      expect(response).to have_http_status(:success)
    end

    it "should NOT let you see my_page if you are NOT logged in" do
      kitchen = FactoryGirl.create(:kitchen)
      get :my_page, params: { id: kitchen.user.last.id }

      expect(response).to redirect_to login_path
    end
  end
end
