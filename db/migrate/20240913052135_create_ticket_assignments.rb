class CreateTicketAssignments < ActiveRecord::Migration[7.2]
  def change
    create_table :ticket_assignments do |t|
      t.references :ticket, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
