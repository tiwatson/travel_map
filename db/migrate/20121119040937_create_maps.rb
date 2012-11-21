class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.integer :id
      t.integer :user_id
      t.string :name
      t.integer :width
      t.string :states_fill
      t.string :states_stroke
      t.string :states_active_fill
      t.string :states_active
      t.string :line_stroke
      t.string :line_stoke_type
      t.string :point_fill
      t.string :point_stroke
      t.string :point_active_fill
      t.string :point_active_stroke

      t.timestamps
    end
  end
end
