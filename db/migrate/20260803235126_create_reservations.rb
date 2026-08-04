class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations do |t|
      t.integer :status
      t.decimal :total, precision: 10, scale: 2
      t.string :confirmation_code
      t.integer :user_id
      t.integer :event_id
      t.timestamps
    end
  end
end
