class CoolpayService

  def initialize(uri=nil, rest_client=nil)
    @uri = uri || 'https://private-anon-9fd2e34449-coolpayapi.apiary-mock.com/api'#'https://coolpay.herokuapp.com/api'
    @rest_client = rest_client || RestClient
  end

  # login ----
  def login(username, api_key)
    raise "Error, invalid username" if username.blank? || !username.is_a?(String)
    raise "Error, invalid api_key" if api_key.blank? || !api_key.is_a?(String)

    url = @uri + '/login'
    params = {'username' => username, 'apikey' => api_key}
    headers = {'content_type' => 'json', 'accept' => 'json'}

    response = @rest_client.post(url, params, headers)

    obj = ActiveSupport::JSON.decode response.body
    obj['token']
  end

  # recipients ----
  def list_recipients(token, filter_by_name=nil)
    raise "Error, invalid token" if token.blank? || !token.is_a?(String)

    url = @uri + '/recipients'
    params = {'name' => filter_by_name}
    # i would expect all the application to be protected ...
    #headers = {'accept' => 'json', "authorization" => "Bearer 12345.#{token}.67890"}
    headers = {'accept' => 'json'}

    response = @rest_client.get(url, {'params' => params, 'headers' => headers})

    obj = ActiveSupport::JSON.decode response.body
    obj['recipients']
  end

  def create_recipient(token, recipient_name)
    raise "Error, invalid token" if token.blank? || !token.is_a?(String)
    raise "Error, invalid recipient_name" if recipient_name.blank? || !recipient_name.is_a?(String)

    url = @uri + '/recipients'
    params = {'recipient' => {'name' => recipient_name}}
    headers = {'content_type' => 'json', 'accept' => 'json', "authorization" => "Bearer 12345.#{token}.67890"}

    response = @rest_client.post(url, {'params' => params, 'headers' => headers})

    obj = ActiveSupport::JSON.decode response.body
    obj['recipient']
  end

  # payments ----
  def list_payments(token)
    raise "Error, invalid token" if token.blank? || !token.is_a?(String)

    url = @uri + '/payments'
    headers = {'accept' => 'json', "authorization" => "Bearer 12345.#{token}.67890"}

    response = @rest_client.get(url, {'headers' => headers})

    obj = ActiveSupport::JSON.decode response.body
    obj['payments']
  end

  def create_payment(token, ammount_bigdecimal, currency, recipient_id)
    raise "Error, invalid token" if token.blank? || !token.is_a?(String)
    raise "Error, invalid ammount_bigdecimal" if ammount_bigdecimal.blank? || !ammount_bigdecimal.is_a?(BigDecimal)
    raise "Error, invalid currency" if currency.blank? || !currency.is_a?(String)
    raise "Error, invalid recipient_id" if recipient_id.blank? || !recipient_id.is_a?(String)

    url = @uri + '/payments'
    params = { "payment" => {"amount" => ammount_bigdecimal, "currency" => currency, "recipient_id" => recipient_id}}
    headers = {'content_type' => 'json', 'accept' => 'json', "authorization" => "Bearer 12345.#{token}.67890"}

    response = @rest_client.post(url, {'params' => params, 'headers' => headers})

    obj = ActiveSupport::JSON.decode response.body
    obj['payments']
  end


end
