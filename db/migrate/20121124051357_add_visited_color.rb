class AddVisitedColor < ActiveRecord::Migration
  def up
    add_column :maps, :states_visited_fill, :string
  end

  def down
    remove_column :maps, :states_visited_fill
  end
end
