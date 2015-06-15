class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string   :name,         null: false
      t.string   :location,     null: false
      t.datetime :start_time,   null: false
      t.datetime :end_time,     null: false
      t.integer  :organizer_id, null: false

      t.timestamps            null: false
    end

    add_foreign_key :events, :users, column: :organizer_id, name: "event_organizer"
  end
end
