class TicketAssignment < ApplicationRecord
  belongs_to :ticket, inverse_of: :ticket_assignment
  belongs_to :user
end
