class AddKmlUrl < ActiveRecord::Migration
  def up
    add_column :maps, :kmlurl, :string
  end

  def down
    remove_column :maps, :kmlurl
  end
end
