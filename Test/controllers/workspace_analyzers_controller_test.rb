require 'test_helper'

class WorkspaceAnalyzersControllerTest < ActionController::TestCase
  setup do
    @workspace_analyzer = workspace_analyzers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:workspace_analyzers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create workspace_analyzer" do
    assert_difference('WorkspaceAnalyzer.count') do
      post :create, workspace_analyzer: { create: @workspace_analyzer.create, environment: @workspace_analyzer.environment, new: @workspace_analyzer.new, results: @workspace_analyzer.results, workspace_id: @workspace_analyzer.workspace_id }
    end

    assert_redirected_to workspace_analyzer_path(assigns(:workspace_analyzer))
  end

  test "should show workspace_analyzer" do
    get :show, id: @workspace_analyzer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @workspace_analyzer
    assert_response :success
  end

  test "should update workspace_analyzer" do
    patch :update, id: @workspace_analyzer, workspace_analyzer: { create: @workspace_analyzer.create, environment: @workspace_analyzer.environment, new: @workspace_analyzer.new, results: @workspace_analyzer.results, workspace_id: @workspace_analyzer.workspace_id }
    assert_redirected_to workspace_analyzer_path(assigns(:workspace_analyzer))
  end

  test "should destroy workspace_analyzer" do
    assert_difference('WorkspaceAnalyzer.count', -1) do
      delete :destroy, id: @workspace_analyzer
    end

    assert_redirected_to workspace_analyzers_path
  end
end
