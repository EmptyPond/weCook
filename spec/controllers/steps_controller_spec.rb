require 'rails_helper'

RSpec.describe StepsController, type: :controller do
  describe "steps#new" do
    it "should allow me to view new step page if I am logged in and own the recipe" do
      kitchen = FactoryGirl.create(:kitchen)
      login_user(kitchen.user.last)
      get :new, params: { kitchen_id: kitchen.id }

      expect(response).to have_http_status(:success)
    end

    it "shouldn't allow me to view new step page if I am not logged in" do
      kitchen = FactoryGirl.create(:kitchen)
      get :new, params: { kitchen_id: kitchen.id }

      expect(response).to redirect_to login_path
    end

    it "shoudn't allow me to view new step page even if I'm logged in but don't own the recipe" do
      kitchen = FactoryGirl.create(:kitchen)
      user = FactoryGirl.create(:user)
      login_user(user)
      get :new, params: {kitchen_id: kitchen.id } 

      expect(response).to redirect_to recipe_kitchen_path(recipe_id:kitchen.recipe.id,id:kitchen.id)
    end
  end

  describe "steps#create" do
    it "should allow us to save steps into the database if we are logged in" do
      kitchen = FactoryGirl.create(:kitchen)
      login_user(kitchen.user.last)
      post :create, params: { kitchen_id: kitchen.id, step: { step_num: 42, description: "life" } }

      expect(Kitchen.last.steps.last.step_num).to eq(42)
      expect(User.last.kitchen.last.steps.last.step_num).to eq(42)
    end

    it "should NOT allow us to save if we are not logged in" do
      kitchen = FactoryGirl.create(:kitchen)
      post :create, params: { kitchen_id: kitchen.id, step: { step_num: 42, description: "life" } }

      expect(response).to redirect_to login_path
    end

    it "should NOT allow us to save if we don't own the recipe" do
      kitchen = FactoryGirl.create(:kitchen)
      user = FactoryGirl.create(:user)
      login_user(user)
      post :create, params: { kitchen_id: kitchen.id, step: { step_num: 42, description: "life" } }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
