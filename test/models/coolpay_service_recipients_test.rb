require 'test_helper'

class CoolpayServiceRecipientsTest < ActiveSupport::TestCase

  setup do
    @uri = "dummy"
    @rest_client = Minitest::Mock.new
    @coolpay_service = CoolpayService.new @uri, @rest_client
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

end
