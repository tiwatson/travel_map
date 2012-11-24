class MapStates < ActiveRecord::Migration
  def up
    add_column :maps, :visited_states, :text
  end

  def down

  end
end
