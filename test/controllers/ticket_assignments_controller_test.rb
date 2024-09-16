require "test_helper"

class TicketAssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ticket_assignment = ticket_assignments(:one)
  end

  test "should get index" do
    get ticket_assignments_url, as: :json
    assert_response :success
  end

  test "should create ticket_assignment" do
    assert_difference("TicketAssignment.count") do
      post ticket_assignments_url, params: { ticket_assignment: { ticket_id: @ticket_assignment.ticket_id, user_id: @ticket_assignment.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show ticket_assignment" do
    get ticket_assignment_url(@ticket_assignment), as: :json
    assert_response :success
  end

  test "should update ticket_assignment" do
    patch ticket_assignment_url(@ticket_assignment), params: { ticket_assignment: { ticket_id: @ticket_assignment.ticket_id, user_id: @ticket_assignment.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy ticket_assignment" do
    assert_difference("TicketAssignment.count", -1) do
      delete ticket_assignment_url(@ticket_assignment), as: :json
    end

    assert_response :no_content
  end
end
