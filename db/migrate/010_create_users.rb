class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,           null: false
      t.string :password_digest, null: false
      t.string :first_name,      null: false
      t.string :last_name,       null: false
      t.boolean :admin,          null: false, default: false
      t.references :role,        null: false

      t.timestamps               null: false
    end

    add_index :users, :email, unique: true
  end
end
