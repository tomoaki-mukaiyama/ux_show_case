require 'test_helper'

class UserFlowControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_flow_index_url
    assert_response :success
  end

end
