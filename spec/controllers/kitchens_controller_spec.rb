require 'rails_helper'

RSpec.describe KitchensController, type: :controller do
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
      expect(response).to redirect_to edit_kitchen_path(id:Kitchen.last.id)
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
end
