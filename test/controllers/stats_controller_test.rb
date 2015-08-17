require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  test "should get topfan" do
    get :topfan
    assert_response :success
  end

end
