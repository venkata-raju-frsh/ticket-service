class TicketSearchController < ApplicationController

  def search
    @tickets = Ticket.search(params[:search_query])
    render json: @tickets
  end
end
