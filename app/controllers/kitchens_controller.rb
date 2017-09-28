class KitchensController < ApplicationController
  before_action :require_login, only: [:new,:create,:edit,:update]

  def new
    @kitchen = Recipe.find(params[:recipe_id]).kitchen.new
  end

  def show
    @kitchen = Kitchen.find(params[:id])
  end

  def create
    @kitchen = current_user.kitchen.new(kitchen_params)
    if @kitchen.save
      redirect_to edit_kitchen_path(id:@kitchen.id)
    else
      redirect_to recipe_path(id:params[:recipe_])
    end
  end

  def edit
    @kitchen = Kitchen.find(params[:id])
    if current_user != @kitchen.user.last
      redirect_to recipe_kitchen_path(recipe_id:params[:recipe_id],id:params[:id])
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

  private 

  def kitchen_params
    params.require(:kitchen).permit(:recipe_id,:name)
  end
end
