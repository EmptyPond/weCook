class RecipesController < ApplicationController
  before_action :require_login, only: [:new,:create,:edit,:update]

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

  def edit
    @recipe = Recipe.find(params[:id])
    #another place where we have to change if we have ownership
    if current_user != @recipe.users.last
      redirect_to recipe_path(params[:id])
    end
  end

  def update
    @recipe = Recipe.find(params[:id])
    #another spot we would have to change if we add explicit ownership of recipes.
    if current_user != @recipe.users.last
      render plain: "Unauthorized!", status: :unauthorized
    elsif @recipe.update(recipe_params)
      #will add an else statement here if we have validations on types of input. 
      redirect_to recipe_path(params[:id])
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name,:description)
  end
end
