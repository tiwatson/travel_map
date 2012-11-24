class AddMapUuid < ActiveRecord::Migration
  def up
    add_column :maps, :token, :string
  end

  def down
    remove_column :maps, :token
  end
end
