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
  describe "steps#edit" do
    it "should let me access the edit page if I am logged in and own the kitchen" do
      step = FactoryGirl.create(:step)
      login_user(step.kitchen.user.last)
      get :edit, params: {id: step.id,kitchen_id: step.kitchen.id }

      expect(response).to have_http_status(:success)
    end

    it "should NOT let me access the edit page if I don't own the kitchen" do
      step = FactoryGirl.create(:step)
      user = FactoryGirl.create(:user)
      login_user(user)
      get :edit, params: {id: step.id,kitchen_id: step.kitchen.id }

      expect(response).to redirect_to recipe_kitchen_path(recipe_id:step.kitchen.recipe.id,id:step.kitchen.id)
    end

    it "should NOT let me access the edit page if I am not logged in" do 
      step = FactoryGirl.create(:step)
      get :edit, params: {id: step.id,kitchen_id: step.kitchen.id }

      expect(response).to redirect_to login_path
    end
  end

  describe "steps#update" do
    it "should let me update the steps" do
      step = FactoryGirl.create(:step)
      login_user(step.kitchen.user.last)
      post :update, params: {id: step.id,kitchen_id: step.kitchen.id, step: {step_num: 42, description: "tons" } }

      expect(response).to redirect_to recipe_kitchen_path(recipe_id: step.kitchen.recipe.id, id: step.kitchen.id)
      expect(Step.last.step_num).to eq(42)
    end

    it "should NOT let me update if I am not logged in" do
      step = FactoryGirl.create(:step)
      post :update, params: {id: step.id,kitchen_id: step.kitchen.id, step: {step_num: 42, description: "tons" } }

      expect(response).to redirect_to login_path
    end

    it "should not let me update if I do not own the kitchen" do
      step = FactoryGirl.create(:step)
      user = FactoryGirl.create(:user)
      login_user(user)
      post :update, params: {id: step.id,kitchen_id: step.kitchen.id, step: {step_num: 42, description: "tons" } }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
