require 'rails_helper'

RSpec.describe IngredientsController, type: :controller do
  describe "ingredients#new" do
    it "should allow me to view new ingredients page if I am logged in and own the recipe" do
      ingredients = FactoryGirl.create(:ingredient)
      login_user(ingredients.kitchen.user.last)
      get :new, params: {kitchen_id: ingredients.kitchen.id}

      expect(response).to have_http_status(:success)
    end

    it "shouldn't allow me to view new ingredients page if I am not logged in" do
      recipe = FactoryGirl.create(:recipe)
      get :new, params: {kitchen_id: recipe.id}

      expect(response).to redirect_to login_path
    end

    it "shoudn't allow me to view new ingredients page even if I'm logged in but don't own the recipe" do
      ingredient = FactoryGirl.create(:ingredient)
      user = FactoryGirl.create(:user)
      login_user(user)
      get :new, params: {kitchen_id: ingredient.kitchen.id}

      expect(response).to redirect_to recipe_kitchen_path(recipe_id:ingredient.kitchen.recipe.id,id:ingredient.kitchen.id)
    end
  end

  describe "ingredients#create" do
    it "should allow us to save ingredients into the database if we are logged in" do
      ingredient = FactoryGirl.create(:ingredient)
      login_user(ingredient.kitchen.user.last)
      post :create, params: { kitchen_id: ingredient.kitchen.id, ingredient: { name: "mushroom", amount: "2 pounds" } }

      expect(Kitchen.last.ingredients.last.name).to eq("mushroom")
      expect(User.last.kitchen.last.ingredients.last.name).to eq("mushroom")
    end

    it "should NOT allow us to save if we are not logged in" do
      recipe = FactoryGirl.create(:recipe)
      post :create, params: { kitchen_id: recipe.id, ingredient: { name: "mushroom", amount: "2 pounds" } }

      expect(response).to redirect_to login_path
    end

    it "should NOT allow us to save if we don't own the recipe" do
      kitchen = FactoryGirl.create(:kitchen)
      user = FactoryGirl.create(:user)
      login_user(user)
      post :create, params: { kitchen_id: kitchen.id, ingredient: { name: "mushroom", amount: "2 pounds" } }

      expect(response).to have_http_status(:unauthorized)
    end
  end
  describe "kitchens#edit" do
    it "should let me access the edit page if I am logged in and own the kitchen" do
      ingredient = FactoryGirl.create(:ingredient)
      login_user(ingredient.kitchen.user.last)
      get :edit, params: {kitchen_id: ingredient.kitchen.id }

      expect(response).to have_http_status(:success)
    end

    it "should NOT let me access the edit page if I don't own the kitchen" do
      ingredient = FactoryGirl.create(:ingredient)
      user = FactoryGirl.create(:user)
      login_user(user)
      get :edit, params: {kitchen_id: ingredient.kitchen.id }

      expect(response).to redirect_to recipe_kitchen_path(recipe_id:ingredient.kitchen.recipe.id,id:ingredient.kitchen.id)
    end

    it "should NOT let me access the edit page if I am not logged in" do 
      ingredient = FactoryGirl.create(:ingredient)
      get :edit, params: {kitchen_id: ingredient.kitchen.id }

      expect(response).to redirect_to login_path
    end
  end

  describe "kitchens#update" do
    it "should let me update the ingredients" do
      ingredient = FactoryGirl.create(:ingredient)
      login_user(ingredient.kitchen.user.last)
      post :update, params: { kitchen_id: ingredient.kitchen.id, ingredient: {name: "new stuff", amount: "tons" } }

      expect(response).to redirect_to recipe_kitchen_path(recipe_id: ingredient.kitchen.recipe.id, id: ingredient.kitchen.id)
      expect(ingredient.last.name).to eq("new stuff")
    end

    it "should NOT let me update if I am not logged in" do
      ingredient = FactoryGirl.create(:ingredient)
      post :update, params: { kitchen_id: ingredient.kitchen.id, ingredient: {name: "new stuff", amount: "tons" } }

      expect(response).to redirect_to login_path
    end

    it "should not let me update if I do not own the kitchen" do
      ingredient = FactoryGirl.create(:ingredient)
      user = FactoryGirl.create(:user)
      login_user(user)
      post :update, params: { kitchen_id: ingredient.kitchen.id, ingredient: {name: "new stuff", amount: "tons" } }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
