class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :label, null: false
    end

    add_index :roles, :label, unique: true
  end
end
