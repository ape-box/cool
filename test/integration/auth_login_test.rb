require 'test_helper'

class AuthLoginTest < ActionDispatch::IntegrationTest
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
end
