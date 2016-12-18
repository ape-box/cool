require 'test_helper'

class RecipientsControllerCreateTest < ActionController::TestCase

  setup do
    @controller = RecipientsController.new

    @mock = Minitest::Mock.new
    def @mock.nil?;false;end
    @mock.expect 'create_recipient', \
      {'id' => '123456', 'name' => 'Pippo'}, \
      ['123456', 'Pippo']
    @controller.coolpay = @mock

    session['token'] = '123456'
  end

  test "unknown users should reditect to login" do
    session.delete 'token'
    post :create, {}
    assert_redirected_to auth_path
  end

  test "known users should see the page" do
    post :create, {'name' => 'Pippo'}
    assert_redirected_to recipients_path
  end

  test "posting a new recipient should call coolapi service" do
    post :create, {'name' => 'Pippo'}
    assert_mock @mock
  end

end
