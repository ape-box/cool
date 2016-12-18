require 'test_helper'

class RecipientsControllerIndexTest < ActionController::TestCase

  setup do
    @controller = RecipientsController.new

    mock = Minitest::Mock.new
    def mock.nil?;false;end
    def mock.list_recipients(*args)
      [{'id' => '123456', 'name' => 'Pippo'}]
    end
    @controller.coolpay = mock

    session['token'] = '123456'
  end

  test "unknown users should reditect to login" do
    session.delete 'token'
    get :index
    assert_redirected_to auth_path
  end

  test "known users should get index" do
    get :index
    assert_response :success
  end

  test "index should retrieve the recipients" do
    get :index
    assert_equal [{'id' => '123456', 'name' => 'Pippo'}], assigns['recipients']
  end

  test "index should show the recipients" do
    get :index
    assert_select 'table#recipients' do
      assert_select 'tr td:first', 'Pippo'
    end
  end

  test "index page should show a form for creating a new recipient" do
    get :index
    assert_select'form#new_recipient[method=post][action=?]', recipients_path do
      assert_select 'input[type=text][name=name]'
    end
  end

end
