class RecipesController < ApplicationController
  before_action :require_login, only: [:new,:create]

  def index
    @recipe = Recipe.all
  end

  def new
    @recipe = Recipe.new
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def create
    @recipe = current_user.recipes.create(recipe_params)
    if @recipe.save
      redirect_to recipe_path(id:@recipe.id)
    else
      redirect_to new_recipe_path
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name,:description)
  end
end
