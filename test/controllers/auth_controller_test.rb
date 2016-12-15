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
    post :login
    assert_response :success
  end

  test "wip" do
    usr = "Pippo"
    post :login, { username: usr }

    assert_response :success
    assert_select 'input[name=username][value=?]', usr
  end
end
