require 'test_helper'

class TossControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get toss_index_url
    assert_response :success
  end

end
