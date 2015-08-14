require 'test_helper'

class AutomatedTestsControllerTest < ActionController::TestCase
  setup do
    @automated_test = automated_tests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:automated_tests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create automated_test" do
    assert_difference('AutomatedTest.count') do
      post :create, automated_test: { datetime: @automated_test.datetime, description: @automated_test.description, int: @automated_test.int, lastrundate: @automated_test.lastrundate, lastruntext: @automated_test.lastruntext, name: @automated_test.name, pass: @automated_test.pass, testid: @automated_test.testid }
    end

    assert_redirected_to automated_test_path(assigns(:automated_test))
  end

  test "should show automated_test" do
    get :show, id: @automated_test
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @automated_test
    assert_response :success
  end

  test "should update automated_test" do
    patch :update, id: @automated_test, automated_test: { datetime: @automated_test.datetime, description: @automated_test.description, int: @automated_test.int, lastrundate: @automated_test.lastrundate, lastruntext: @automated_test.lastruntext, name: @automated_test.name, pass: @automated_test.pass, testid: @automated_test.testid }
    assert_redirected_to automated_test_path(assigns(:automated_test))
  end

  test "should destroy automated_test" do
    assert_difference('AutomatedTest.count', -1) do
      delete :destroy, id: @automated_test
    end

    assert_redirected_to automated_tests_path
  end
end
