require "test_helper"

class CandiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get candies_index_url
    assert_response :success
  end

  test "should get show" do
    get candies_show_url
    assert_response :success
  end

  test "should get new" do
    get candies_new_url
    assert_response :success
  end

  test "should get create" do
    get candies_create_url
    assert_response :success
  end

  test "should get edit" do
    get candies_edit_url
    assert_response :success
  end

  test "should get update" do
    get candies_update_url
    assert_response :success
  end

  test "should get destroy" do
    get candies_destroy_url
    assert_response :success
  end
end
