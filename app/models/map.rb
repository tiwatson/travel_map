class Map < ActiveRecord::Base
  belongs_to :user

  serialize :visited_states, Array

  attr_accessible :id, :kmlurl, :visited_states, :line_stoke_type, :line_stroke, :name, :point_active_fill, :point_active_stroke, :point_fill, :point_stroke, :states_active, :states_active_fill, :states_fill, :states_stroke, :user_id, :width, :states_visited_fill

  validates_uniqueness_of :token

  before_create :token_generate
  after_save :js_generate, :css_generate


  # attrs based off others
  def height
    (self.width.to_f * (9.to_f/16.to_f)).to_i
  end

  def scale
    return self.width + 150
  end

  def token_generate
    self.token = rand(36**8).to_s(36)
  end

  def js_generate
    template = Erubis::Eruby.new File.new(Rails.root.join('public','templates','d3_map.js')).read
    File.open(self.js_path, 'w') { |file| file.write(template.result(:map => self)) }
  end

  def css_generate
    template = Erubis::Eruby.new File.new(Rails.root.join('public','templates','d3_map.css')).read
    File.open(self.css_path, 'w') { |file| file.write(template.result(:map => self)) }
  end

  def kml_update
    return if self.kmlurl.blank?

    ## USE CACHE FOR NOW ##
    self.download_and_save_kml unless self.kmldata.exist?

    doc = Nokogiri::XML(open(self.kmldata))
    doc.remove_namespaces!


    ##### TRACK #####

    coords = doc.xpath('//Document/Placemark/LineString/coordinates').map do |i|
      i.children[0].to_s.gsub(',0.000000','').split("\n").collect { |x| x.split(',').collect{ |n| n.to_f }}.reject{ |y| y.size <= 1} 
    end

    coords = coords.flatten(1)
    logger.debug "Points Found #{coords.size}"
    if (coords.size > 1000) 
      coords = coords.select_with_index { |v,i| (i % (coords.size/1000) == 0) }
    end

    logger.debug "Points Used #{coords.size}"

    ##### POINTS #####

    points = doc.xpath('//Document/Placemark').map do |i|
      next if i.xpath('Point')[0].nil?

      i_points = i.xpath('Point/coordinates').text.gsub(',0.000000','').split(',').map{ |n| n.to_f }

      # Reverse geocode lat/lng... and cache it.
      dc_i = Digest::MD5.hexdigest(i_points.join(','))

      begin
        gc = @@diskcache.get( dc_i )
      rescue Diskcached::NotFound
        gc = Geocoder.search("#{i_points[1]},#{i_points[0]}")
        @@diskcache.set(dc_i, gc)
      end

      {
        :type => "Feature", 
        :properties => {:name => i.xpath('name').text, :description => i.xpath('description').text, :city => gc.first.city, :state => gc.first.state}, 
        :geometry => {:type => 'Point', :coordinates => i_points}
      }

    end

    output = {:points => points.compact, :track => [{:type => 'Feature', :id => '01', :properties => {:name => 'Linestring'}, :geometry => {:type => 'LineString', :coordinates => coords }}]}

    File.open(self.jsondata, 'w') { |file| file.write(JSON.generate(output)) }

    self.kmlupdated = Time.now
    self.kmlstatus = 1
    self.save
    
  end

  def storage_path
    pf = Rails.root.join('public','maps',self.token)
    pf.mkpath unless pf.exist?
    return pf
  end

  def kmldata
    self.storage_path.join('data.kml')
  end

  def jsondata
    self.storage_path.join('data.json')
  end

  def js_path
    self.storage_path.join('map.js')
  end

  def css_path
    self.storage_path.join('map.css')
  end

  def js_url
    "/maps/#{self.token}/map.js"
  end

  def css_url
    "/maps/#{self.token}/map.css"
  end

  def download_and_save_kml
    logger.debug "Downloading KML #{self.kmldata}"
    File.open(self.kmldata, 'wb') do |file|
      file << open(self.kmlurl).read
    end
  end



  after_initialize do
    if self.new_record?
      self.name = 'New Map'
      self.width = 900
      self.states_fill = '#ccc'
      self.states_stroke = '#fff'
      self.states_visited_fill = '#aaa'
      self.states_active_fill = '#36648B'
      self.states_active = '#fff'
      self.line_stroke = '#222'
      self.line_stoke_type = 'dashedarray'
      self.point_fill = '#8B3639'
      self.point_stroke = '#fff'
      self.point_active_fill = '#142635'
      self.point_active_stroke = '#fff'

    end
  end
end
