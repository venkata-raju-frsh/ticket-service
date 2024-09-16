class TicketAttachment < ApplicationRecord

  belongs_to :ticket
  has_one_attached :file

  def file_url
    Rails.application.routes.url_helpers.url_for(file)
  end
end
