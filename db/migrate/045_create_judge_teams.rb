class CreateJudgeTeams < ActiveRecord::Migration
  def change
    create_table :judge_teams do |t|
      t.integer :judge_id, null: false
      t.integer :team_id, null: false

      t.timestamps null: false
    end

    add_index :judge_teams, [:judge_id, :team_id], unique: true
    add_foreign_key :judge_teams, :event_teams,  name: "judge_team_team",  column: "team_id", on_delete: :cascade
    add_foreign_key :judge_teams, :event_judges, name: "judge_team_judge", column: "judge_id", on_delete: :cascade
  end
end
