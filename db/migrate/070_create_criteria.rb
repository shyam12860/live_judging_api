class CreateCriteria < ActiveRecord::Migration
  def change
    create_table :criteria do |t|
      t.string :label, null: false
      t.integer :min_score, null: false, default: 0
      t.integer :max_score, null: false, default: 5
      t.references :rubric

      t.timestamps null: false
    end

    add_foreign_key :criteria, :rubrics, name: "category_rubric"
  end
end
