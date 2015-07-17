class CreateRubricCategories < ActiveRecord::Migration
  def change
    create_table :rubric_categories do |t|
      t.references :rubric, null: false
      t.integer :category_id, null: false

      t.timestamps null: false
    end

    add_foreign_key :rubric_categories, :rubrics, name: "rubric_category_rubric"
    add_foreign_key :rubric_categories, :event_categories, name: "rubric_category_category", column: "category_id"
  end
end
