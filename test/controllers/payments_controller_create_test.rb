require 'test_helper'

class PaymentsControllerCreateTest < ActionController::TestCase

  setup do
    @controller = PaymentsController.new

    @mock = Minitest::Mock.new
    def @mock.nil?;false;end
    @mock.expect 'create_payment', \
      {'id' => '123456', 'amount' => '10.5', 'currency' => 'GBP', 'recipient_id' => '456', 'status' => 'paid'}, \
      ['123456', BigDecimal.new('10.5'), 'GBP', '456']
    @controller.coolpay = @mock

    session['token'] = '123456'
  end

  test "unknown users should reditect to login" do
    session.delete 'token'
    post :create, {}
    assert_redirected_to auth_path
  end

  test "known users should see the page" do
    post :create, {"amount" => '10.5', "currency" => "GBP", "recipient_id" => "456"}
    assert_redirected_to payments_path
  end

  test "posting a new payment should call coolapi service" do
    post :create, {"amount" => '10.5', "currency" => "GBP", "recipient_id" => "456"}
    assert_mock @mock
  end

end
