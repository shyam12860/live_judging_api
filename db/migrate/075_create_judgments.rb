class CreateJudgments < ActiveRecord::Migration
  def change
    create_table :judgments do |t|
      t.integer :value,        null: false
      t.integer :team_id,      null: false
      t.integer :judge_id,     null: false
      t.references :criterion, null: false

      t.timestamps null: false
    end

    add_index :judgments, [:judge_id, :team_id, :criterion_id], unique: true
    add_foreign_key :judgments, :criteria,     name: "judgment_criterion"
    add_foreign_key :judgments, :event_teams,  name: "judgment_team",  column: "team_id"
    add_foreign_key :judgments, :event_judges, name: "judgment_judge", column: "judge_id"
  end
end
