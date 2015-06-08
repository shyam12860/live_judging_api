class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :access_token, null: false
      t.datetime :expires_at, null: false, default: 2.weeks.from_now
      t.references :user

      t.timestamps null: false
    end

    add_index :tokens, :access_token, unique: true
  end
end
