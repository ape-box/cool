class AuthController < ApplicationController
  def index
  end

  def login
    @username = params["username"]
    render 'index'
  end
end
