require "test_helper"

class TicketAttachmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ticket_attachment = ticket_attachments(:one)
  end

  test "should get index" do
    get ticket_attachments_url, as: :json
    assert_response :success
  end

  test "should create ticket_attachment" do
    assert_difference("TicketAttachment.count") do
      post ticket_attachments_url, params: { ticket_attachment: { ticket_id: @ticket_attachment.ticket_id } }, as: :json
    end

    assert_response :created
  end

  test "should show ticket_attachment" do
    get ticket_attachment_url(@ticket_attachment), as: :json
    assert_response :success
  end

  test "should update ticket_attachment" do
    patch ticket_attachment_url(@ticket_attachment), params: { ticket_attachment: { ticket_id: @ticket_attachment.ticket_id } }, as: :json
    assert_response :success
  end

  test "should destroy ticket_attachment" do
    assert_difference("TicketAttachment.count", -1) do
      delete ticket_attachment_url(@ticket_attachment), as: :json
    end

    assert_response :no_content
  end
end
