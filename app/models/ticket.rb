class Ticket < ApplicationRecord
  include Searchable

  has_many :ticket_attachments
  belongs_to :user
  has_one :ticket_assignment

  VALID_STATUSES = [ "NEW", "ASSIGNED", "INPROGRESS", "COMPLETED", "CLOSED", "ARCHIVED" ]
  VALID_STATUSES_FOR_TICKET_CREATE_USER = [ "CLOSED", "ARCHIVED" ]
  VALID_STATUSES_FOR_TICKET_AGENT = [ "INPROGRESS", "COMPLETED"]
  before_create :set_new_status_to_ticket

  validates :title, presence: true, length: { maximum: 100 }
  validates :status, inclusion: { in: VALID_STATUSES, message: "status should be a valid Ticket status" }

  private
    def set_new_status_to_ticket
      self.status = VALID_STATUSES[0]
      Rails.logger.info("Before create callback")
    end
end
