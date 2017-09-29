class StaticPagesController < ApplicationController
  before_action :require_login, only: :my_page
  def index
  end

  def my_page
  end
end
