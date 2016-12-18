require 'test_helper'

class AuthControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
  end

  test "index shows login form" do
    get :index
    assert_select 'form[method=post][action=?]', auth_login_path do
      assert_select 'input[name=username]'
      assert_select 'input[name=api_key]'
    end
  end

  test "should post login" do
    mock = Minitest::Mock.new
    def mock.post(*args); Response.new('{"token": "1234567890"}'); end
    Rails.application.config.rest_client = mock

    post :login
    assert_response :redirect
    assert_equal '1234567890', session['token']
  end

  test "login should redirect to recipients list" do
    mock = Minitest::Mock.new
    def mock.post(*args); Response.new('{"token": "1234567890"}'); end
    Rails.application.config.rest_client = mock

    post :login
    assert_response :redirect
    assert_redirected_to recipients_path
  end

end
