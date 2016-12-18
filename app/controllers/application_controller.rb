class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def coolpay
    if @coolpay_service.nil?
      CoolpayService.new Rails.application.config.coolpay_uri, Rails.application.config.rest_client
    else
      @coolpay_service
    end
  end

  def coolpay=(coolpay_service)
    @coolpay_service = coolpay_service
  end

  def authorized?
    redirect_to auth_path if session['token'].blank?
  end

end
