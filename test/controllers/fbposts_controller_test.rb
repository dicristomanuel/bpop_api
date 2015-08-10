require 'test_helper'

class FbpostsControllerTest < ActionController::TestCase
  setup do
    @fbpost = fbposts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fbposts)
  end

  test "should create fbpost" do
    assert_difference('Fbpost.count') do
      post :create, fbpost: { date: @fbpost.date, identity_token: @fbpost.identity_token, integer: @fbpost.integer, likes: @fbpost.likes, message: @fbpost.message, story: @fbpost.story, url: @fbpost.url }
    end

    assert_response 201
  end

  test "should show fbpost" do
    get :show, id: @fbpost
    assert_response :success
  end

  test "should update fbpost" do
    put :update, id: @fbpost, fbpost: { date: @fbpost.date, identity_token: @fbpost.identity_token, integer: @fbpost.integer, likes: @fbpost.likes, message: @fbpost.message, story: @fbpost.story, url: @fbpost.url }
    assert_response 204
  end

  test "should destroy fbpost" do
    assert_difference('Fbpost.count', -1) do
      delete :destroy, id: @fbpost
    end

    assert_response 204
  end
end
