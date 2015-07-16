class AddTokensToUser < ActiveRecord::Migration
  def change
    add_column :users, :gcm_token, :string
    add_column :users, :apn_token, :string
  end
end
