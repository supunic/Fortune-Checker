require 'test_helper'

class PpsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pps_index_url
    assert_response :success
  end

end
