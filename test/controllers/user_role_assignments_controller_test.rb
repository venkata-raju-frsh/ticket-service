require "test_helper"

class UserRoleAssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_role_assignment = user_role_assignments(:one)
  end

  test "should get index" do
    get user_role_assignments_url, as: :json
    assert_response :success
  end

  test "should create user_role_assignment" do
    assert_difference("UserRoleAssignment.count") do
      post user_role_assignments_url, params: { user_role_assignment: {} }, as: :json
    end

    assert_response :created
  end

  test "should show user_role_assignment" do
    get user_role_assignment_url(@user_role_assignment), as: :json
    assert_response :success
  end

  test "should update user_role_assignment" do
    patch user_role_assignment_url(@user_role_assignment), params: { user_role_assignment: {} }, as: :json
    assert_response :success
  end

  test "should destroy user_role_assignment" do
    assert_difference("UserRoleAssignment.count", -1) do
      delete user_role_assignment_url(@user_role_assignment), as: :json
    end

    assert_response :no_content
  end
end
