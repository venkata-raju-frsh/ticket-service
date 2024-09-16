class SendCreateTicketEmailJob
  include Sidekiq::Job

  def perform(ticket_id)
    @ticket = Ticket.find(ticket_id)
    TicketMailer.new_ticket_email("test@test.com", @ticket).deliver_now
  end
end
