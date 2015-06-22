class CreateEventOrganizers < ActiveRecord::Migration
  def change
    create_table :event_organizers do |t|
      t.references :event,     null: false
      t.integer :organizer_id, null: false

      t.timestamps null: false
    end

    add_index :event_organizers, [:event_id, :organizer_id], unique: true
    add_foreign_key :event_organizers, :events, name: "event_organizer_event"
    add_foreign_key :event_organizers, :users, name: "event_organizer_organizer", column: "organizer_id"
  end
end
