class CreateTicketAttachments < ActiveRecord::Migration[7.2]
  def change
    create_table :ticket_attachments do |t|
      t.references :ticket, null: false, foreign_key: true

      t.timestamps
    end
  end
end
