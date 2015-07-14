class CreateEventTeams < ActiveRecord::Migration
  def change
    create_table :event_teams do |t|
      t.string :logo_id, unique: true
      t.string :name, null: false
      t.references :event, index: true, null: false

      t.timestamps null: false
    end

    add_index :event_teams, [:event_id, :name], unique: true
    add_foreign_key :event_teams, :events, name: "event_team_event", on_delete: :cascade
  end
end
