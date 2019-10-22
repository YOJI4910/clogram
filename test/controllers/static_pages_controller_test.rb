require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get policy" do
    get static_pages_policy_url
    assert_response :success
  end

end
