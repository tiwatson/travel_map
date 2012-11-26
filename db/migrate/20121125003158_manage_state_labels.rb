class ManageStateLabels < ActiveRecord::Migration
  def up
    add_column :maps, :state_label, :boolean, :default => true
    add_column :maps, :state_label_color, :string
  end

  def down
    remove_column :maps, :state_label
    remove_column :maps, :state_label_color
  end
end
