class AuthController < ApplicationController

  def index
  end

  def login
    # This is supposed to virtually substitute the facebook login,
    # I am making the assumption this in reality is coming from an
    # internal source, while this is meant as mockup for it
    token = coolpay.login params['username'], params['api_key']
    session['token'] = token

    @token = session['token']

    render 'index'
  end

end
