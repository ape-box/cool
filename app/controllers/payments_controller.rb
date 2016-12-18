class PaymentsController < ApplicationController
  before_action "authorized?"

  def index
    tmp_payments = coolpay.list_payments session['token']
    @recipients = coolpay.list_recipients

    @payments = tmp_payments.collect! do |p|
      recipient = @recipients.find {|r| r['id'] == p['recipient_id']}
      p['recipient'] = recipient.nil? ? p['recipient_id'] : recipient['name']
      p
    end
  end

  def create
    amount = BigDecimal.new(params['amount'])
    raise "Invalid amount" unless amount > 0

    coolpay.create_payment session['token'], amount, params['currency'], params['recipient_id']

    redirect_to payments_path
  end

end
