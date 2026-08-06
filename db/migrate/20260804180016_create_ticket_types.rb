class CreateTicketTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :ticket_types do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.integer :event_id
      t.integer :quantity
      t.timestamps
    end
  end
end
