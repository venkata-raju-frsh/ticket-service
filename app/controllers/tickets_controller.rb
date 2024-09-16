class TicketsController < ApplicationController
  include SecurityController
  before_action :set_ticket, only: %i[ update destroy update_status]
  before_action :set_ticket_id, only: %i[ show update destroy update_status ]

  @@all_tickets_cache_key = "tickets#index"
  @@tickets_for_user_cache_key = "tickets#userid"
  @@ticket_cache_key = "ticket#id"

  # GET /tickets
  def index
    if isAdmin? || isAgent?
      Rails.logger.info("Tickets#index admin & agent flow")
      @tickets = Rails.cache.fetch(@@all_tickets_cache_key, expires_in: 30.minutes) do
        Rails.logger.info("Cache miss: Retrieved tickets from database")
        Ticket.all.to_a
      end
    end

    if isRegular?
      @tickets = Rails.cache.fetch(user_ticket_cache_key(@current_user_id), expires_in: 30.minutes) do
      Rails.logger.info("Cache miss: Retrieved tickets from database")
      Ticket.find_by(:user_id => @current_user_id)
      end
    end
    render json: @tickets == nil ? [] : @tickets.to_json(include: [{ticket_attachments: {methods: :file_url}},:ticket_assignment])
  end

  # GET /tickets/1
  def show
    Rails.logger.info("Tickets#show & ticket #{@ticket_id}")
    @ticket = Rails.cache.fetch(ticket_cache_key(@ticket_id), expires_in: 30.minutes) do
      Rails.logger.info("Cache miss: Retrieved tickets from database")
      Ticket.find(@ticket_id)
    end
    if ticket_belongs_to_user? || isAdmin? || isAgent?
      render json: @ticket.to_json(include: [{ticket_attachments: {methods: :file_url}},:ticket_assignment])
    else
      render json: { error: "Not Authorized" }, status: 403
    end
  end

  # POST /tickets
  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.user_id = @current_user_id
    if @ticket.save
      Rails.logger.info("Ticket created")
      Rails.cache.delete(@@all_tickets_cache_key)
      SendCreateTicketEmailJob.perform_async(@ticket.id)
      render json: @ticket.to_json(include: [{ticket_attachments: {methods: :file_url}},:ticket_assignment]),status: :created, location: @ticket
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tickets/1
  def update
    if @ticket.update(ticket_params)
      Rails.cache.delete(ticket_cache_key(@ticket_id))
      Rails.cache.delete(user_ticket_cache_key(@current_user_id))
      Rails.cache.delete(@@all_tickets_cache_key)
      render json: @ticket.to_json(include: [{ticket_attachments: {methods: :file_url}},:ticket_assignment])
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tickets/1
  def destroy
    @ticket.destroy!
    Rails.cache.delete(ticket_cache_key(@ticket_id))
    Rails.cache.delete(user_ticket_cache_key(@current_user_id))
    Rails.cache.delete(@@all_tickets_cache_key)
  end

  def update_status
    @new_status = params[:status]
    if @ticket.user_id.to_s == @current_user_id && Ticket::VALID_STATUSES_FOR_TICKET_CREATE_USER.include?(@new_status)
      @ticket.status = @new_status
      @ticket.save
      render json: @ticket
      return
    else
      render json: { error: "Status change not allowed" }, status: 400
      return
    end

    if @current_user_id.to_s == @ticket.ticket_assignment.user_id.to_s && Ticket::VALID_STATUSES_FOR_TICKET_AGENT.include?(@new_status)
      @ticket.status = @new_status
      @ticket.save
      render json: @ticket
      return
    else
      render json: { error: "Status change not allowed" }, status: 400
      return
    end

    if isAdmin?
      @ticket.status = @new_status
      @ticket.save
      render json: @ticket
      return
    end
    render json: { error: "Status change not allowed" }, status: 400
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

  def set_ticket_id
    @ticket_id = params[:id]
  end

    # Only allow a list of trusted parameters through.
    def ticket_params
      params.require(:ticket).permit(:title, :description, :status)
    end

  def ticket_status_update_params
    params.require(:ticket).permit(:status)
  end

  def user_ticket_cache_key(current_user_id)
    @@tickets_for_user_cache_key + ":" + current_user_id.to_s
  end
  def ticket_cache_key(ticket_id)
    @@ticket_cache_key + ":" + ticket_id.to_s
  end

  def ticket_belongs_to_user?
    @ticket.user_id.to_s == @current_user_id
  end
end
