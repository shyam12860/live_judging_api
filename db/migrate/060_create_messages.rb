class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject,       null: false
      t.string :body,          null: false
      t.integer :sender_id,    null: false
      t.integer :recipient_id, null: false
      t.timestamp :read
    end

    add_foreign_key :messages, :users, name: "message_sender",    column: "sender_id"
    add_foreign_key :messages, :users, name: "message_recipient", column: "recipient_id"
  end
end
