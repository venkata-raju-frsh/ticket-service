class TicketMailer < ApplicationMailer
	default from: 'ticket-admin@tickets.com'

	def new_ticket_email(email, ticket)
		@url = url_for(ticket)
		mail(to: 'ramaraju.gva@gmail.com', subject: "New Ticket Created!")
		Rails.logger.info "Email sent to #{email}"
	end
end
