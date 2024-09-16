require "test_helper"

class UserRolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_role = user_roles(:one)
  end

  test "should get index" do
    get user_roles_url, as: :json
    assert_response :success
  end

  test "should create user_role" do
    assert_difference("UserRole.count") do
      post user_roles_url, params: { user_role: { description: @user_role.description, name: @user_role.name } }, as: :json
    end

    assert_response :created
  end

  test "should show user_role" do
    get user_role_url(@user_role), as: :json
    assert_response :success
  end

  test "should update user_role" do
    patch user_role_url(@user_role), params: { user_role: { description: @user_role.description, name: @user_role.name } }, as: :json
    assert_response :success
  end

  test "should destroy user_role" do
    assert_difference("UserRole.count", -1) do
      delete user_role_url(@user_role), as: :json
    end

    assert_response :no_content
  end
end
