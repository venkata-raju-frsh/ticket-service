class TicketAttachmentsController < ApplicationController
  include SecurityController
  before_action :set_ticket_attachment, only: %i[ show destroy ]

  # GET /ticket_attachments
  def index
    @ticket_attachments = TicketAttachment.where(ticket_id: params[:ticket_id])
    render json: @ticket_attachments, methods: [:file_url]
  end

  # GET /ticket_attachments/1
  def show
    @attachment_url = url_for(@ticket_attachment.file)
    render json: @ticket_attachment, methods: [:file_url]
  end

  # POST /ticket_attachments
  def create
    @ticket = Ticket.find(params[:ticket_id])
    @ticket_attachment = @ticket.ticket_attachments.create(ticket_attachment_params)

    if @ticket_attachment
      render json: @ticket_attachment, status: :created
    else
      render json: @ticket_attachment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ticket_attachments/1
  def destroy
    @ticket_attachment.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket_attachment
      @ticket_attachment = TicketAttachment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ticket_attachment_params
      params.permit(:file, :ticket_id)
    end
end
