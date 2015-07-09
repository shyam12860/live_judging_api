class CreateRubrics < ActiveRecord::Migration
  def change
    create_table :rubrics do |t|
      t.string :name, null: false
      t.references :event, null: false
      t.timestamps null: false
    end

    add_index :rubrics, :name
    add_foreign_key :rubrics, :events, name: "rubric_event"
  end
end
