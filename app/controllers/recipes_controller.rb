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
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      @kitchen = current_user.kitchen.create(name: "#{current_user.email}'s kitchen",recipe_id:@recipe.id)
      redirect_to recipe_kitchen_path(recipe_id:@recipe.id,id:@kitchen.id)
    else
      redirect_to new_recipe_path
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
    #will need to edit when we add the function for multiple users to own a single kitchen
    if current_user != @recipe.kitchen.last.user.last
      redirect_to recipe_path(params[:id])
    end
  end

  def update
    @recipe = Recipe.find(params[:id])
    #another spot we would have to change if we add explicit ownership of recipes.
    if current_user != @recipe.kitchen.last.user.last
      render plain: "Unauthorized!", status: :unauthorized
    elsif @recipe.update(recipe_params)
      #will add an else statement here if we have validations on types of input. 
      redirect_to recipe_path(params[:id])
    else
      redirect_to edit_recipe_path(params[:id])
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name,:description)
  end
end
