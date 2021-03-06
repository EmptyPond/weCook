require 'rails_helper'

RSpec.describe KitchensController, type: :controller do
  describe "kitchens#new" do
    it "should allow me to access the new kitchen page if I'm logge in" do
      kitchen = FactoryGirl.create(:kitchen)
      login_user(kitchen.user.last)
      get :new, params: {recipe_id: kitchen.recipe.id }

      expect(response).to have_http_status(:success)
    end

    it "should NOT allow me to access if i'm NOT logged in" do
      kitchen = FactoryGirl.create(:kitchen)
      get :new, params: {recipe_id: kitchen.recipe.id }

      expect(response).to redirect_to login_path
    end
  end
  describe "kitchens#show" do
    it "should let me see the kitchen show page" do
      kitchen = FactoryGirl.create(:kitchen)
      get :show, params: { recipe_id: kitchen.recipe.id, id: kitchen.id }

      expect(response).to have_http_status(:success)
    end
  end

  describe "kitchens#create" do
    it "should allow me to create a kitchen if I'm logged in" do
      kitchen = FactoryGirl.create(:kitchen)
      login_user(kitchen.user.last)
      post :create, params: {recipe_id: kitchen.recipe.id, kitchen: { name: "this kitchen", recipe_id: kitchen.recipe.id } }

      expect(Kitchen.last.name).to eq("this kitchen")
      expect(response).to redirect_to recipe_kitchen_path(recipe_id:kitchen.recipe.id,id:Kitchen.last.id)
    end

    it "should NOT allow me to create a kitchen if I'm not logged in" do
      recipe = FactoryGirl.create(:recipe)
      post :create, params: {recipe_id: recipe.id} 

      expect(response).to redirect_to login_path
    end
  end

  describe "kitchens#edit" do
    it "should allow me to see the kitchen edit page" do
      kitchen = FactoryGirl.create(:kitchen)
      login_user(kitchen.user.last)
      get :edit, params: { recipe_id: kitchen.recipe.id, id: kitchen.id} 

      expect(response).to have_http_status(:success)
    end

    it "should redirct me it i'm not logged in" do
      kitchen = FactoryGirl.create(:kitchen)
      get :edit, params: { recipe_id: kitchen.recipe.id, id: kitchen.id }

      expect(response).to redirect_to login_path
    end

    it "should NOT let me see the edit page if the kitchen is NOT mine" do
      kitchen = FactoryGirl.create(:kitchen)
      user = FactoryGirl.create(:user)
      login_user(user)
      get :edit, params: { recipe_id: kitchen.recipe.id, id: kitchen.id}

      expect(response).to redirect_to recipe_kitchen_path(recipe_id:kitchen.recipe.id,id:kitchen.id)
    end
  end

  describe "kitchenes#update" do
    it "should allow me to update the kitchen" do
      kitchen = FactoryGirl.create(:kitchen)
      login_user(kitchen.user.last)
      patch :update, params: { recipe_id: kitchen.recipe.id, id: kitchen.id, kitchen: { name: "new!" } }

      expect(Kitchen.last.name).to eq("new!")
    end
    it "should NOT allow me to update if kitchen NOT mine" do
      kitchen = FactoryGirl.create(:kitchen)
      user = FactoryGirl.create(:user)
      login_user(user)
      patch :update, params: { recipe_id: kitchen.recipe.id, id: kitchen.id, kitchen: { name: "new!" } }

      expect(response).to have_http_status(:unauthorized)
    end

    it "should redirect me if I'm not logged in" do
      kitchen = FactoryGirl.create(:kitchen)
      patch :update, params: { recipe_id: kitchen.recipe.id, id: kitchen.id, kitchen: { name: "new!" } }
      
      expect(response).to redirect_to login_path
    end
  end
  describe "kitchens#new_copy" do
    it "should allow me to view the new copy page a existing kitchen if I'm logged in" do
      kitchen = FactoryGirl.create(:kitchen)
      login_user(kitchen.user.last)
      get :new_copy, params: { kitchen_id: kitchen.id }

      expect(response).to have_http_status(:success)
    end

    it "should NOT allow me to view the new copy if I'm not logged in" do
      kitchen = FactoryGirl.create(:kitchen)
      get :new_copy, params: { kitchen_id: kitchen.id }

      expect(response).to redirect_to login_path
    end
  end

  describe "kitchens#create_copy" do
    it "should allow me to create copy a existing kitchen if I'm logged in" do
      ingredients = FactoryGirl.create(:ingredient)
      login_user(ingredients.kitchen.user.last)
      post :create_copy, params: { kitchen_id: ingredients.kitchen.id, kitchen: { name: "kitchen_copy", recipe_id: ingredients.kitchen.recipe.id } }
      kitchen2 = Kitchen.last

      expect(response).to redirect_to recipe_kitchen_path(recipe_id:kitchen2.recipe.id,id:kitchen2.id)
      expect(kitchen2.name).to eq("kitchen_copy")
      expect(kitchen2.ingredients.first.name).to eq("awesome")
    end

    it "should NOT allow me to create a copy if I'm not logged in" do
      kitchen = FactoryGirl.create(:kitchen)
      post :create_copy, params: { kitchen_id: kitchen.id , name: "kitchen_copy" }

      expect(response).to redirect_to login_path
    end
  end
end
