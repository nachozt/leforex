require 'test_helper'

class CompareControllerTest < ActionDispatch::IntegrationTest
  #
  # describe index
  #
  test "should get index on root path" do
    get root_path
    assert_response :success
  end

  #
  # describe today
  #
  test "should get today" do
    get today_path
    assert_response :success
  end
end
