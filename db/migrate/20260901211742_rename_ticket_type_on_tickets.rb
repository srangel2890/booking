class RenameTicketTypeOnTickets < ActiveRecord::Migration[8.0]
  def change
    rename_column :tickets, :ticket_type, :ticket_type_id
  end
end