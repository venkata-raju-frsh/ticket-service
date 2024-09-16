class AddUserToTicket < ActiveRecord::Migration[7.2]
  def change
    add_reference :tickets, :user, null: false, foreign_key: true
  end
end
