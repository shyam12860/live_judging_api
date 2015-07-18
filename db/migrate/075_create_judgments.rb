class CreateJudgments < ActiveRecord::Migration
  def change
    create_table :judgments do |t|
      t.integer :value,            null: false
      t.integer :judge_id,         null: false
      t.references :criterion,     null: false
      t.references :team_category, null: false

      t.timestamps null: false
    end

    add_index :judgments, [:judge_id, :team_category_id, :criterion_id], unique: true, name: "judgments_unique_index"
    add_foreign_key :judgments, :criteria,        name: "judgment_criterion",     on_delete: :cascade
    add_foreign_key :judgments, :team_categories, name: "judgment_team_category", on_delete: :cascade
    add_foreign_key :judgments, :event_judges,    name: "judgment_judge",         column: "judge_id", on_delete: :cascade
  end
end
