class CreateEventCategories < ActiveRecord::Migration
  def change
    create_table :event_categories do |t|
      t.references :event, index: true, null: false
      t.string   :label,   null: false
      t.integer  :color,   null: false
      t.datetime :due_at
      t.string   :description

      t.timestamps null: false
    end

    add_index :event_categories, [:event_id, :label], unique: true
    add_foreign_key :event_categories, :events, name: "event_category_event"
  end
end
