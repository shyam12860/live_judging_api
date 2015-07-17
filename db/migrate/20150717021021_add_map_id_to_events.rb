class AddMapIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :map_id, :string
  end
end
