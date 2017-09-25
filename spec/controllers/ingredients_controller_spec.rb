require 'rails_helper'

RSpec.describe IngredientsController, type: :controller do
  describe "ingredients#new" do
    it "should allow me to view new step page if I am logged in and own the recipe" do
      kit = FactoryGirl.create(:kitchen)
      login_user(kit.user)
      get :new, params: {recipe_id: kit.recipe.id}

      expect(response).to have_http_status(:success)
    end

    it "shouldn't allow me to view new step page if I am not logged in" do
      kit = FactoryGirl.create(:kitchen)
      get :new, params: {recipe_id: kit.recipe.id}

      expect(response).to redirect_to login_path
    end

    it "shoudn't allow me to view new step page even if I'm logged in but don't own the recipe" do
      recipe = FactoryGirl.create(:recipe)
      user = FactoryGirl.create(:user)
      login_user(user)
      get :new, params: {recipe_id: recipe.id}

      expect(response).to redirect_to recipe_path(recipe.id)
    end
  end

  describe "ingredients#create" do
    it "should allow us to save ingredients into the database if we are logged in" do
      kit = FactoryGirl.create(:kitchen)
      login_user(kit.user)
      post :create, params: { recipe_id: kit.recipe.id, ingredients: { name: "mushroom", amount: "2 pounds" } }

      expect(Recipe.last.ingredients.last.name).to eq("mushroom")
      expect(User.last.recipes.last.ingredients.last.name).to eq("mushroom")
    end

    it "should NOT allow us to save if we are not logged in" do
      kit = FactoryGirl.create(:kitchen)
      post :create, params: { recipe_id: kit.recipe.id, ingredients: { name: "mushroom", amount: "2 pounds" } }

      expect(response).to redirect_to login_path
    end

    it "should NOT allow us to save if we don't own the recipe" do
      recipe = FactoryGirl.create(:recipe)
      user = FactoryGirl.create(:user)
      login_user(user)
      post :create, params: { recipe_id: recipe.id, ingredients: { name: "mushroom", amount: "2 pounds" } }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
