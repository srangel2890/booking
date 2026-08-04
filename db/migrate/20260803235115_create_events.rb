class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.string :description
      t.datetime :starts_at
      t.datetime :ends_at 
      t.datetime :sales_end_date
      t.integer :capacity
      t.integer :status
      t.integer :user_id, null: false
      t.integer :venue_id 
      t.timestamps
    end
  end
end
