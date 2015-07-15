class CreatePlatforms < ActiveRecord::Migration
  def change
    create_table :platforms do |t|
      t.string :label, null: false
    end
    add_index :platforms, :label, unique: true
  end
end
