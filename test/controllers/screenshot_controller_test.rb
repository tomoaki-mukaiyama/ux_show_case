require 'test_helper'

class ScreenshotControllerTest < ActionDispatch::IntegrationTest
  test "should get tag_index" do
    get screenshot_tag_index_url
    assert_response :success
  end

end
