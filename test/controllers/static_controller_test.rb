require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  test "index redirect to auth" do
    get :index
    assert_response :redirect
  end
end
