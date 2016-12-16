class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def coolpay
    CoolpayService.new Rails.application.config.coolpay_uri, Rails.application.config.rest_client
  end

end
