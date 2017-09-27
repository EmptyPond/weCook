class StepsController < ApplicationController
  before_action :require_login, only: [:new,:create]

  def new
    #probably needs to be refactored due to being long
    #is this actually how I'm suppose to add ingredeints to recipe? feels smelly
    @step = Kitchen.find(params[:recipe_id]).steps.new
    #this will need to change because later multiple people will be able to follow a recipe
    #also do we want an "owner" of a recipe?
    if current_user != @step.kitchen.user.last
      #should add alert here telling user that they can't edit this
      redirect_to recipe_path(params[:recipe_id])
    end
  end

  def create
    @step = Kitchen.find(params[:recipe_id]).steps.new(steps_params)
    if current_user != @step.kitchen.user.last
      render plain: "Unauthorized!", status: :unauthorized
    elsif @step.save
      redirect_to recipe_path(params[:recipe_id])
    else
      #this will be if the inputs aren't ok. doesn't validate currently. 
      redirect_to new_recipe_ingredient_path(recipe_id:params[:recipe_id])
    end
  end
  private

  def steps_params
    params.require(:step).permit(:step_num,:description)
  end
end
