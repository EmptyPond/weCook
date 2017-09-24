require 'rails_helper'

RSpec.describe RecipesController, type: :controller do

  describe "recipes#index" do
    it "should show the recipes index page (has list of recipes)" do
      get :index

      expect(response).to have_http_status(:success)
    end
  end

  describe "recipes#new" do
    it "should show the new recipes page" do
      get :new

      expect(response).to have_http_status(:success)
    end
  end
  
  describe "recipes#show" do
    it "should show a recipe we planted" do
      recipe = FactoryGirl.create(:recipe)
      get :show, params: { id: recipe.id }

      expect(response).to have_http_status(:success)
    end
  end

  describe "recipes#create" do
    it "should allow us to create a new recipe" do
      user = FactoryGirl.create(:user)
      login_user(user)
      post :create, params: { recipe: { name: "Another epic recipe", description: "food" } }

      recipe = Recipe.last
      expect(response).to redirect_to recipes_path(recipe.id)
      expect(recipe.description).to eq("food")
      expect(recipe.user).to eq(user)
    end
  end
end
