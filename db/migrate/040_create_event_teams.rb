class CreateEventTeams < ActiveRecord::Migration
  def change
    create_table :event_teams do |t|
      t.string :logo_id, unique: true
      t.string :name, null: false
      t.references :event, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    add_index :event_teams, [:event_id, :name], unique: true
  end
end
