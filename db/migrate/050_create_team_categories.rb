class CreateTeamCategories < ActiveRecord::Migration
  def change
    create_table :team_categories do |t|
      t.integer :team_id, null: false
      t.integer :category_id, null: false

      t.timestamps null: false
    end

    add_index :team_categories, [:team_id, :category_id], unique: true
    add_foreign_key :team_categories, :event_teams,      name: "team_category_team",     column: "team_id", on_delete: :cascade
    add_foreign_key :team_categories, :event_categories, name: "team_category_category", column: "category_id", on_delete: :cascade
  end
end
