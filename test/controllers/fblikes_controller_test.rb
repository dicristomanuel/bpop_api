require 'test_helper'

class FblikesControllerTest < ActionController::TestCase
  setup do
    @fblike = fblikes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fblikes)
  end

  test "should create fblike" do
    assert_difference('Fblike.count') do
      post :create, fblike: {  }
    end

    assert_response 201
  end

  test "should show fblike" do
    get :show, id: @fblike
    assert_response :success
  end

  test "should update fblike" do
    put :update, id: @fblike, fblike: {  }
    assert_response 204
  end

  test "should destroy fblike" do
    assert_difference('Fblike.count', -1) do
      delete :destroy, id: @fblike
    end

    assert_response 204
  end
end
