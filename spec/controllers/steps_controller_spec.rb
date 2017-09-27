require 'rails_helper'

RSpec.describe StepsController, type: :controller do
  describe "steps#new" do
    it "should allow me to view new step page if I am logged in and own the recipe" do
      recipe = FactoryGirl.create(:recipe)
      login_user(recipe.kitchen.last.user.last)
      get :new, params: { recipe_id: recipe.id }

      expect(response).to have_http_status(:success)
    end

    it "shouldn't allow me to view new step page if I am not logged in" do
      recipe = FactoryGirl.create(:recipe)
      get :new, params: { recipe_id: recipe.id }

      expect(response).to redirect_to login_path
    end

    it "shoudn't allow me to view new step page even if I'm logged in but don't own the recipe" do
      recipe = FactoryGirl.create(:recipe)
      user = FactoryGirl.create(:user)
      login_user(user)
      get :new, params: {recipe_id: recipe.id } 

      expect(response).to redirect_to recipe_path(recipe.id)
    end
  end

  describe "steps#create" do
    it "should allow us to save steps into the database if we are logged in" do
      recipe = FactoryGirl.create(:recipe)
      login_user(recipe.kitchen.last.user.last)
      post :create, params: { recipe_id: recipe.id, step: { step_num: 42, description: "life" } }

      expect(Kitchen.last.steps.last.step_num).to eq(42)
      expect(User.last.kitchen.last.steps.last.step_num).to eq(42)
    end

    it "should NOT allow us to save if we are not logged in" do
      recipe = FactoryGirl.create(:recipe)
      post :create, params: { recipe_id: recipe.id, step: { step_num: 42, description: "life" } }

      expect(response).to redirect_to login_path
    end

    it "should NOT allow us to save if we don't own the recipe" do
      recipe = FactoryGirl.create(:recipe)
      user = FactoryGirl.create(:user)
      login_user(user)
      post :create, params: { recipe_id: recipe.id, step: { step_num: 42, description: "life" } }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
