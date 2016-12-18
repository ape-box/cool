class StaticController < ActionController::Base
  def index
    redirect_to auth_path
  end
end
