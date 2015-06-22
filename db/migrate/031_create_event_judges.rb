class CreateEventJudges < ActiveRecord::Migration
  def change
    create_table :event_judges do |t|
      t.references :event, null: false
      t.integer :judge_id, null: false
    end

    add_index :event_judges, [:event_id, :judge_id], unique: true
    add_foreign_key :event_judges, :events, name: "event_judge_event"
    add_foreign_key :event_judges, :users, column: :judge_id, name: "event_judge_judge"
  end
end
