class CoolpayService

  def initialize(uri=nil, rest_client=nil)
    @uri = uri || 'https://private-anon-9fd2e34449-coolpayapi.apiary-mock.com/api'#'https://coolpay.herokuapp.com/api'
    @rest_client = rest_client || RestClient
  end

  # login ----
  def login(username, api_key)
    response = @rest_client.post(
      @uri + '/login',
      {'username' => username, 'apikey' => api_key},
      {'content_type' => 'json', 'accept' => 'json'})

    return_body_content response, 'token'
  end

  # recipients ----
  def list_recipients(filter_by_name=nil)
    response = @rest_client.get(
      @uri + '/recipients', {
        'params' => {'name' => filter_by_name},
        'headers' => {'accept' => 'json'}})

    return_body_content response, 'recipients'
  end

  def create_recipient(token, recipient_name)
    response = @rest_client.post(
      @uri + '/recipients', {
        'params' => {'recipient' => {'name' => recipient_name}},
        'headers' => headers_post(token)})

    return_body_content response, 'recipient'
  end

  # payments ----
  def list_payments(token)
    response = @rest_client.get(
      @uri + '/payments',
      {'headers' => headers_get(token)})

    return_body_content response, 'payments'
  end

  def create_payment(token, ammount_bigdecimal, currency, recipient_id)
    raise 'Error, invalid ammount_bigdecimal' unless ammount_bigdecimal.is_a?(BigDecimal)

    response = @rest_client.post(
      @uri + '/payments', {
        'params' => {
          'payment' => {
            'amount' => ammount_bigdecimal,
            'currency' => currency,
            'recipient_id' => recipient_id}},
        'headers' => headers_post(token)})

    return_body_content response, 'payment'
  end

  private

    def headers_post(token)
      {'content_type' => 'json', 'accept' => 'json', 'authorization' => "Bearer 12345.#{token}.67890"}
    end

    def headers_get(token)
      {'accept' => 'json', 'authorization' => "Bearer 12345.#{token}.67890"}
    end

    def return_body_content(response, namespace=nil)
      obj = ActiveSupport::JSON.decode response.body
      namespace.nil? ? obj : obj[namespace]
    end

end
