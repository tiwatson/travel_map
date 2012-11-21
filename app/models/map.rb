class Map < ActiveRecord::Base
  belongs_to :user

  attr_accessible :id, :kmlurl, :line_stoke_type, :line_stroke, :name, :point_active_fill, :point_active_stroke, :point_fill, :point_stroke, :states_active, :states_active_fill, :states_fill, :states_stroke, :user_id, :width






  after_initialize do
    if self.new_record?
      self.name = 'New Map'
      self.width = 900
      self.states_fill = '#ccc'
      self.states_stroke = '#fff'
      self.states_active_fill = '#36648B'
      self.states_active = '#fff'
      self.line_stroke = '#222'
      self.line_stoke_type = 'dashed'
      self.point_fill = '#8B3639'
      self.point_stroke = '#fff'
      self.point_active_fill = '#142635'
      self.point_active_stroke = '#fff'

    end
  end
end
