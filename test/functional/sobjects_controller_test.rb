require 'test_helper'

class SobjectsControllerTest < ActionController::TestCase
  setup do
    @sobject = sobjects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sobjects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sobject" do
    assert_difference('Sobject.count') do
      post :create, sobject: @sobject.attributes
    end

    assert_redirected_to sobject_path(assigns(:sobject))
  end

  test "should show sobject" do
    get :show, id: @sobject.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sobject.to_param
    assert_response :success
  end

  test "should update sobject" do
    put :update, id: @sobject.to_param, sobject: @sobject.attributes
    assert_redirected_to sobject_path(assigns(:sobject))
  end

  test "should destroy sobject" do
    assert_difference('Sobject.count', -1) do
      delete :destroy, id: @sobject.to_param
    end

    assert_redirected_to sobjects_path
  end
end
