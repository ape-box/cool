require 'test_helper'

class RoutesTest < ActionController::TestCase
  test "static routes" do
    assert_routing({ method: :get, path: '/' }, { controller: 'static', action: 'index' })
  end

  test "auth routes" do
    assert_routing({ method: :get, path: '/auth' }, { controller: 'auth', action: 'index' })
    assert_routing({ method: :post, path: '/auth/login' }, { controller: 'auth', action: 'login' })
  end
end
