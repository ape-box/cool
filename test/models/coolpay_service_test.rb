require 'test_helper'

class CoolpayServiceTest < ActiveSupport::TestCase

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

  # recipients ----
  test "list_recipients should return the 'recipients' inside the response's body" do
    @rest_client.expect 'get', Response.new('{"recipients": [{"id": "123456", "name": "Jake"}]}'), [
      @uri+'/recipients',
      {'params' => {'name' => nil}, 'headers' => {'accept' => 'json'}}]

    recipients = @coolpay_service.list_recipients

    assert_mock @rest_client
    assert_equal [{'id' => '123456', 'name' => 'Jake'}], recipients
  end

  test "list_recipients should pass on the 'name' param" do
    @rest_client.expect 'get', Response.new('{"recipients": [{"id": "123456", "name": "Jake"}]}'), [
      @uri+'/recipients',
      {'params' => {'name' => 'Jake'}, 'headers' => {'accept' => 'json'}}]

    recipients = @coolpay_service.list_recipients 'Jake'

    assert_mock @rest_client
    assert_equal [{'id' => '123456', 'name' => 'Jake'}], recipients
  end

  test "create_recipient should should receive the new recipient data" do
    @rest_client.expect 'post', Response.new('{"recipient": {"id": "123456", "name": "Jake"}}'), [
      @uri+'/recipients',
      {'params' => {'recipient' => {'name' => 'Jake'}},
       'headers' => {'content_type' => 'json', 'accept' => 'json', 'authorization' => 'Bearer 12345.1234567890.67890'}}]

    recipient = @coolpay_service.create_recipient '1234567890', 'Jake'

    assert_mock @rest_client
    assert_equal({'id' => '123456', 'name' => 'Jake'}, recipient)
  end

  # payments ----
  test "list_payments should return the 'payments' inside the response's body" do
    @rest_client.expect 'get', Response.new(
      '{"payments": [{"id": "123", "amount": "10.50", "currency": "GBP", "recipient_id": "456", "status": "paid"}]}'),
      [@uri+'/payments', {'headers' => {'accept' => 'json', 'authorization' => 'Bearer 12345.1234567890.67890'}}]

    payments = @coolpay_service.list_payments '1234567890'

    assert_mock @rest_client
    assert_equal [{"id" => "123", "amount" => "10.50", "currency" => "GBP", "recipient_id" => "456", "status" => "paid"}], payments
  end

  test "create_payment should should receive the new payment data" do
    @rest_client.expect 'post', Response.new(
      '{"payment": {"id": "123", "amount": "10.5", "currency": "GBP", "recipient_id": "456", "status": "processing"}}'),
      [@uri+'/payments',
        {'params' => {"payment" => {"amount" => BigDecimal.new('10.5'), "currency" => "GBP", "recipient_id" => "456"}},
         'headers' => {'content_type' => 'json', 'accept' => 'json', 'authorization' => 'Bearer 12345.1234567890.67890'}}]

    recipient = @coolpay_service.create_payment '1234567890', BigDecimal.new('10.5'), 'GBP', '456'

    assert_mock @rest_client
    assert_equal({"id" => "123", "amount" => "10.5", "currency" => "GBP", "recipient_id" => "456", "status" => "processing"}, recipient)
  end
end

class Response
  attr_accessor :body
  def initialize(json_content)
    @body = json_content
  end
end
