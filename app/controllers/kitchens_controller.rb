class KitchensController < ApplicationController
  before_action :require_login, only: [:new,:create,:edit,:update,:new_copy,:create_copy]

  def new
    @kitchen = Recipe.find(params[:recipe_id]).kitchen.new
  end

  def show
    @kitchen = Kitchen.find(params[:id])
  end

  def create
    @kitchen = current_user.kitchen.new(kitchen_params)
    if @kitchen.save
      redirect_to recipe_kitchen_path(recipe_id:params[:recipe_id],id:@kitchen.id)
    else
      redirect_to recipe_path(id:params[:recipe_id])
    end
  end

  def edit
    @kitchen = Kitchen.find(params[:id])
    if current_user != @kitchen.user.last
      redirect_to recipe_kitchen_path(recipe_id:@kitchen.recipe.id,id:params[:id])
    end
  end

  def update
    @kitchen = Kitchen.find(params[:id])
    if current_user != @kitchen.user.last
      render plain: "Unauthorized!", status: :unauthorized
    elsif @kitchen.update(kitchen_params)
      redirect_to recipe_kitchen_path(recipe_id:params[:recipe_id],id:params[:id])
      #should add else clause to deal if @kitchen not saving
    end
  end

  def new_copy
  end

  def create_copy
    @new_kitchen = current_user.kitchen.new(kitchen_params)
    @copied_kitchen = Kitchen.find(params[:kitchen_id])
    if @new_kitchen.save
      @copied_kitchen.ingredients.each do |i|
        @new_kitchen.ingredients.create(name: i.name, amount: i.amount)
      end
      @copied_kitchen.steps.each do |s|
        @new_kitchen.steps.create(step_num: s.step_num, description: s.description)
      end
      redirect_to recipe_kitchen_path(recipe_id:@new_kitchen.recipe.id,id:@new_kitchen.id)
    else
      redirect_to recipe_kitchen_path(recipe_id:@copied_kitchen.recipe.id,id:@copied_kitchen.id)
    end
  end

  private 

  def kitchen_params
    params.require(:kitchen).permit(:recipe_id,:name)
  end
end
