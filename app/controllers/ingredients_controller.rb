class IngredientsController < ApplicationController
  before_action :require_login, only: [:new,:create]

  def new
    #probably needs to be refactored due to being long
    #is this actually how I'm suppose to add ingredeints to recipe? feels smelly
    @ingredient = Recipe.find(params[:recipe_id]).ingredients.new
    #this will need to change because later multiple people will be able to follow a recipe
    #also do we want an "owner" of a recipe?
    if current_user != @ingredient.recipe.users.last
      #should add alert here telling user that they can't edit this
      redirect_to recipe_path(params[:recipe_id])
    end
  end

  def create
    @ingredient = Recipe.find(params[:recipe_id]).ingredients.new(ingredients_params)
    #same as new we need to change this
    if current_user != @ingredient.recipe.users.last
      render plain: "Unauthorized!", status: :unauthorized
    elsif @ingredient.save
      redirect_to recipe_path(params[:recipe_id])
    else
      #this will be if the inputs aren't ok. doesn't validate currently. 
      redirect_to new_recipe_ingredient_path(recipe_id:params[:recipe_id])
    end
  end

  private

  def ingredients_params
    params.require(:ingredient).permit(:name,:amount)
  end
end
