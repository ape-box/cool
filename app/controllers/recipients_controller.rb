class RecipientsController < ApplicationController
  before_action "authorized?"

  def index
    @recipients = coolpay.list_recipients params['name']
  end

  def create
    unless params['name'].blank?
      coolpay.create_recipient session['token'], params['name']
    end
    redirect_to recipients_path
  end

end
