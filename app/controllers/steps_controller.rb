class StepsController < ApplicationController
  before_action :require_login, only: :new
  def new
    #probably needs to be refactored due to being long
    #is this actually how I'm suppose to add ingredeints to recipe? feels smelly
    @step = Recipe.find(params[:recipe_id]).steps.new
    #this will need to change because later multiple people will be able to follow a recipe
    #also do we want an "owner" of a recipe?
    if current_user != @step.recipe.users.last
      #should add alert here telling user that they can't edit this
      redirect_to recipe_path(params[:recipe_id])
    end
  end

  private

  def ingredients_params
    params.require(:ingredients).permit(:name,:amount)
  end
end
