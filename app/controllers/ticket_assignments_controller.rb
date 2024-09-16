class TicketAssignmentsController < ApplicationController
  include SecurityController
  before_action :set_ticket_assignment, only: %i[ show update destroy ]
  before_action :allow_only_admin, only: %i[ create update destroy ]


  @@all_tickets_cache_key = 'tickets#index'
  @@tickets_for_user_cache_key = 'tickets#userid'
  @@ticket_cache_key = 'ticket#id'

  # GET /ticket_assignments
  def index
    @ticket_assignments = TicketAssignment.all
    render json: @ticket_assignments
  end

  # GET /ticket_assignments/1
  def show
    render json: @ticket_assignment
  end

  # POST /ticket_assignments
  def create
    @ticket = Ticket.find(params[:ticket_id])
    @assigned_user = User.find(params[:user_id])
    unless @assigned_user.user_roles.to_a.include?("AGENT")
      render json: {error: "Assigned user is not an AGENT"}, status: 400
      return
    end
    unless @ticket.ticket_assignment == nil
      render json: {error: "Agent is already assinged to ticket. Use update"}, status: 400
      return
    end
    @ticket.update(status: "ASSIGNED")
    @ticket_assignment = @ticket.build_ticket_assignment(ticket_assignment_params)
    if @ticket.save
      Rails.cache.delete(ticket_cache_key(@ticket.id))
      Rails.cache.delete(user_ticket_cache_key(@current_user_id))
      Rails.cache.delete(@@all_tickets_cache_key)
      render json: @ticket_assignment, status: :created
    else
      render json: @ticket_assignment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /ticket_assignments/1
  def update
    @assigned_user = User.find(params[:user_id])
    unless @assigned_user.user_roles..to_a.include?("AGENT")
      render json: {error: "Assigned user is not an AGENT"}, status: 400
      return
    end
    if @ticket_assignment.update(ticket_assignment_params)
      render json: @ticket_assignment
    else
      render json: @ticket_assignment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ticket_assignments/1
  def destroy
    @ticket_assignment.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket_assignment
      @ticket_assignment = TicketAssignment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ticket_assignment_params
      params.require(:ticket_assignment).permit(:ticket_id, :user_id)
    end

    def allow_only_admin
      unless isAdmin?
        render json: {error: "Not Authorized to assign agent to ticket"}, status: :forbidden
      end
    end


    def user_ticket_cache_key(current_user_id)
      @@tickets_for_user_cache_key + ":" + current_user_id.to_s
    end
    def ticket_cache_key(ticket_id)
      @@ticket_cache_key + ":" + ticket_id.to_s
    end
end
