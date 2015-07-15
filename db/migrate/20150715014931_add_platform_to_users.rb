class AddPlatformToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :platform, index: true
    add_foreign_key :users, :platforms, name: "user_platform"
  end
end
