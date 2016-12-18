require 'test_helper'

class CoolpayServiceLoginTest < ActiveSupport::TestCase

  setup do
    @uri = "dummy"
    @rest_client = Minitest::Mock.new
    @coolpay_service = CoolpayService.new @uri, @rest_client
  end

  # login ----
  test "login should return the 'token' inside the response's body" do
    @rest_client.expect 'post', Response.new('{"token": "1234567890"}'), [
      @uri+'/login',
      {'username' => 'username', 'apikey' => 'apikey'},
      {'content_type' => 'json', 'accept' => 'json'}]

    token = @coolpay_service.login 'username', 'apikey'

    assert_mock @rest_client
    assert_equal '1234567890', token
  end

end
