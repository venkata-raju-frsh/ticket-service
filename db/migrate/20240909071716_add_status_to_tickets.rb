class AddStatusToTickets < ActiveRecord::Migration[7.2]
  def change
    add_column :tickets, :status, :string
  end
end
