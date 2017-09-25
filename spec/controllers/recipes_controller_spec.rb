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

  describe "recipes#edit" do
    it "should allow us to view the edit page if we own the recipe" do
      kit = FactoryGirl.create(:kitchen)
      login_user(kit.user)
      get :edit, params: { id: kit.recipe.id }

      expect(response).to have_http_status(:success)
    end

    it "shouldn't allow us to view the edit page if we do not own the recipe" do
      user = FactoryGirl.create(:user)
      recipe = FactoryGirl.create(:recipe)
      login_user(user)
      get :edit, params: { id: recipe.id }

      expect(response).to redirect_to recipe_path(recipe)
    end

    it "shouldn't allow us to view the edit page if we are not logged in" do
      recipe = FactoryGirl.create(:recipe)
      get :edit, params: { id: recipe.id }

      expect(response).to redirect_to login_path
    end
  end

  describe "recipes#update" do
    it "should allow me to update a recipe" do
      kit = FactoryGirl.create(:kitchen)
      login_user(kit.user)
      patch :update, params: { id: kit.recipe.id, recipe: { name: "updated!", description: "delicious!" } }

      expect(Recipe.last.name).to eq("updated!")
    end

    it "should NOT allow us to update if we don't own the recipe" do
      recipe = FactoryGirl.create(:recipe)
      user = FactoryGirl.create(:user)
      login_user(user)
      patch :update, params: { id: recipe.id, recipe: { name: "updated!", description: "delicious!" } }

      expect(response).to have_http_status(:unauthorized)
    end

    it "should NOT allow us to update if we are not logged in" do
      kit = FactoryGirl.create(:kitchen)
      patch :update, params: { id: kit.recipe.id, recipe: { name: "updated!", description: "delicious!" } }

      expect(response).to redirect_to login_path
    end
  end
end
