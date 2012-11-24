namespace :parse_kml do
  task :parse => :environment do
    @diskcache = Diskcached.new('geocoder_cache',  (86400*365))

    User.all.each do |user| 
      puts user.id
      user.maps.each do |map|
        puts map.kmlurl
        map.kml_update
      end
    end
  end
end
