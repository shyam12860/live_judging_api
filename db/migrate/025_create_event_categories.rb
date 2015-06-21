class CreateEventCategories < ActiveRecord::Migration
  def change
    create_table :event_categories do |t|
      t.references :event, index: true,  foreign_key: true, null: false
      t.string :label,     null: false

      t.timestamps null: false
    end

    add_index :event_categories, [:event_id, :label], unique: true
  end
end
