require 'test_helper'

class AuthLoginTest < ActionDispatch::IntegrationTest

  setup do
    mock = Minitest::Mock.new
    def mock.post(*args); Response.new('{"token": "123456"}'); end
    Rails.application.config.rest_client = mock
  end

  test "http should redirect" do
    get auth_path
    assert_response :redirect
  end

  test "ensure http redirect" do
    https!
    get auth_path
    assert_response :success
  end

  test "user land on root" do
    https!
    get root_path
    assert_redirected_to auth_path
  end

  test "once logged in, the user should be redirected to the recipients controller" do
    https!
    post auth_login_path, {'username' => 'username', 'api_key' => 'api_key'}
    assert_redirected_to recipients_path
  end

end
