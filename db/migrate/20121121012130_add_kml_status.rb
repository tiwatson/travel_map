class AddKmlStatus < ActiveRecord::Migration
  def up
    add_column :maps, :kmlupdated, :datetime
    add_column :maps, :kmlstatus, :integer, :default => 0
  end

  def down
    remove_column :maps, :kmlupdated 
    remove_column :maps, :kmlstatus
  end
end
