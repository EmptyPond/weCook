class SessionsController < ApplicationController
  def new
  end

  def create
    user = login(params[:email],params[:password])
    if user
      redirect_to root_path
    else
      redirect_to login_path
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end
