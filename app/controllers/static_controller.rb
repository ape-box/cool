class StaticController < ApplicationController

  def index
    redirect_to auth_path
  end

  def dashboard
  end

end
