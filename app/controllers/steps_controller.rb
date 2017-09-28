class StepsController < ApplicationController
  before_action :require_login, only: [:new,:create,:edit,:update]

  def new
    #probably needs to be refactored due to being long
    #is this actually how I'm suppose to add ingredeints to recipe? feels smelly
    @step = Kitchen.find(params[:kitchen_id]).steps.new
    #this will need to change because later multiple people will be able to follow a recipe
    #also do we want an "owner" of a recipe?
    if current_user != @step.kitchen.user.last
      #should add alert here telling user that they can't edit this
      redirect_to recipe_kitchen_path(recipe_id:@step.kitchen.recipe.id,id:@step.kitchen.id)
    end
  end

  def create
    @step = Kitchen.find(params[:kitchen_id]).steps.new(steps_params)
    if current_user != @step.kitchen.user.last
      render plain: "Unauthorized!", status: :unauthorized
    elsif @step.save
      redirect_to recipe_kitchen_path(recipe_id:@step.kitchen.recipe.id,id:params[:kitchen_id])
    else
      #this will be if the inputs aren't ok. doesn't validate currently. 
      redirect_to new_kitchen_step_path(kitchen_id:params[:kitchen_id])
    end
  end

  def edit
    @step = Step.find(params[:id])
    if current_user != @step.kitchen.user.last
      redirect_to recipe_kitchen_path(recipe_id:@step.kitchen.recipe.id,id:@step.kitchen.id)
    end
  end

  def update
    @step = Step.find(params[:id])
    if current_user != @step.kitchen.user.last
      render plain: "Unauthorized!", status: :unauthorized
    else @step.update(steps_params)
      redirect_to recipe_kitchen_path(recipe_id:@step.kitchen.recipe.id,id:@step.kitchen.id)
    end
  end
  private

  def steps_params
    params.require(:step).permit(:step_num,:description)
  end
end
