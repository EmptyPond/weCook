require 'rails_helper'

RSpec.describe RecipesController, type: :controller do

  describe "recipes#index" do
    it "should show the recipes index page (has list of recipes)" do
      get :index

      expect(response).to have_http_status(:success)
    end
  end

  describe "recipes#new" do
    it "should show the new recipes page if I am logged in" do
      user = FactoryGirl.create(:user)
      login_user(user)
      get :new

      expect(response).to have_http_status(:success)
    end

    it "shouldn't let not logged in users to view the new recipe page" do
      get :new

      expect(response).to redirect_to login_path
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
      expect(response).to redirect_to recipe_path(recipe.id)
      expect(recipe.description).to eq("food")
      expect(recipe.users.last).to eq(user)
    end

    it "shouldn't allow us to create a recipe if we are not logged in" do
      post :create, params: { recipe: { name: "recipe", description:"another one" } }

      expect(response).to redirect_to login_path
      expect(Recipe.count).to eq(0)
    end
  end
end
