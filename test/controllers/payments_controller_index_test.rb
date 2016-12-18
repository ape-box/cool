require 'test_helper'

class PaymentsControllerIndexTest < ActionController::TestCase

  setup do
    @controller = PaymentsController.new

    @mock = Minitest::Mock.new
    def @mock.nil?;false;end
    def @mock.list_payments(*args)
      [{'id' => '123', 'amount' => '10.50', 'currency' => 'GBP', 'recipient_id' => '456', 'status' => 'paid'}]
    end
    def @mock.list_recipients(*args)
      [{'id' => '456', 'name' => 'Pippo'}]
    end
    @controller.coolpay = @mock

    session['token'] = '123456'
  end

  test "unknown users should redirect to login" do
    session.delete 'token'
    get :index
    assert_redirected_to auth_path
  end

  test "known users should get index" do
    get :index
    assert_response :success
  end

  test "index should retrieve the payments" do
    get :index
    assert_equal [{
        'id' => '123',
        'amount' => '10.50',
        'currency' => 'GBP',
        'recipient' => 'Pippo',
        'recipient_id' => '456',
        'status' => 'paid'}],
      assigns['payments']
  end

  test "index page should show a form for creating a new payment" do
    get :index
    assert_select'form#new_payment[method=post][action=?]', payments_path do
      assert_select 'input[type=text][name=amount]'
      assert_select 'select[name=currency]'
      assert_select 'select[name=recipient_id]'
    end
  end

end
