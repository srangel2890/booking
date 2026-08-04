class CreateTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :tickets do |t|
      t.string :code, null: false
      t.integer :reservation_id, null: false
      t.integer :ticket_type
      t.string :attendee_name
      t.string :attendee_email
      t.timestamps
      t.index :code, unique: true
    end
  end
end
