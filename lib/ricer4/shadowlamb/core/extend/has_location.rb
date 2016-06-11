module Ricer4::Plugins::Shadowlamb::Core::Extend::HasLocation
  
  PRECISION = 6

  def guid; class_eval{|klass|klass.name.substr_from('World::')}; end
  
  def on_floor(floor)
    class_eval do |klass|
      klass.instance_variable_set(:@sl5_floor, floor)
      def floor; self.class.instance_variable_get(:@sl5_floor); end
    end
  end
  
  def has_lat(lat); class_eval{|klass|klass.instance_variable_set(:@sl5_lat, lat.round(PRECISION))}; end
  def has_lon(lon); class_eval{|klass|klass.instance_variable_set(:@sl5_lon, lon.round(PRECISION))}; end
  def has_radius(radius); class_eval{|klass|klass.instance_variable_set(:@sl5_radius, radius.round(PRECISION))}; end
  def has_minlat(lat); class_eval{|klass|klass.instance_variable_set(:@sl5_minlat, lat.round(PRECISION))}; end
  def has_minlon(lon); class_eval{|klass|klass.instance_variable_set(:@sl5_minlon, lon.round(PRECISION))}; end
  def has_maxlat(lat); class_eval{|klass|klass.instance_variable_set(:@sl5_maxlat, lat.round(PRECISION))}; end
  def has_maxlon(lon); class_eval{|klass|klass.instance_variable_set(:@sl5_maxlon, lon.round(PRECISION))}; end
  
  def has_point(lat, lon)
    class_eval do |klass|
      lat, lon = klass.has_lat(lat), klass.has_lon(lon)
      def lat; self.class.instance_variable_get(:@sl5_lat); end
      def lon; self.class.instance_variable_get(:@sl5_lon); end
      def minlat; lat; end; def minlon; lon; end
      def maxlat; lat; end; def maxlon; lon; end
    end
  end

  def has_position(radius=1)
    class_eval do |klass|
      klass.has_radius(radius)
      def lat; self.latitude; end
      def lon; self.longitude; end
      def radius; @radius ||= self.class.instance_variable_get(:@sl5_radius); end
      def minlat; Ricer4::Plugins::Shadowlamb::Core::Coords.transform_lat(self.lat, self.lon, -self.radius); end
      def minlon; Ricer4::Plugins::Shadowlamb::Core::Coords.transform_lon(self.lat, self.lon, -self.radius); end
      def maxlat; Ricer4::Plugins::Shadowlamb::Core::Coords.transform_lat(self.lat, self.lon, self.radius); end
      def maxlon; Ricer4::Plugins::Shadowlamb::Core::Coords.transform_lon(self.lat, self.lon, self.radius); end
    end
  end

  def has_coordinates(lat1, lon1, lat2, lon2)
    class_eval do |klass|
      minlat,minlon = klass.has_minlat([lat1, lat2].min), klass.has_minlon([lon1, lon2].min)
      maxlat,maxlon = klass.has_maxlat([lat1, lat2].max), klass.has_maxlon([lon1, lon2].max)
      lat,lon = klass.has_lat((minlat+maxlat)/2), klass.has_lon((minlon+maxlon)/2)
      def lat; self.class.instance_variable_get(:@sl5_lat); end
      def lon; self.class.instance_variable_get(:@sl5_lon); end
      def minlat; self.class.instance_variable_get(:@sl5_minlat); end
      def minlon; self.class.instance_variable_get(:@sl5_minlon); end
      def maxlat; self.class.instance_variable_get(:@sl5_maxlat); end
      def maxlon; self.class.instance_variable_get(:@sl5_maxlon); end
    end
  end
  
  def is_location(lat1, lon1, lat2, lon2)
    class_eval do |klass|
      klass.has_coordinates(lat1, lon1, lat2, lon2)
      shadowverse.add_location(klass)
    end
  end
  
  def has_location(lat, lon, radius=2)
    class_eval do |klass|
      minlat = Ricer4::Plugins::Shadowlamb::Core::Coords.transform_lat(lat, lon, -radius)
      minlon = Ricer4::Plugins::Shadowlamb::Core::Coords.transform_lon(lat, lon, -radius)
      maxlat = Ricer4::Plugins::Shadowlamb::Core::Coords.transform_lat(lat, lon, radius)
      maxlon = Ricer4::Plugins::Shadowlamb::Core::Coords.transform_lon(lat, lon, radius)
      klass.is_location(minlat, minlon, maxlat, maxlon)
    end
  end
  
  def has_area(lat1, lon1, lat2, lon2)
    class_eval do |klass|
      klass.has_coordinates(lat1, lon1, lat2, lon2)
      shadowverse.add_area(klass)
    end
  end
  
  def has_stairs(action_sym=:parking)
    has_down_stairs(action_sym)
    has_up_stairs(action_sym)
  end

  def has_down_stairs(action_sym=:parking)
    class_eval do |klass|
      klass.instance_variable_set(:@sl5_has_down_stairs, action_sym)
    end
  end

  def has_up_stairs(action_sym=:parking)
    class_eval do |klass|
      klass.instance_variable_set(:@sl5_has_up_stairs, action_sym)
    end
  end
 
  def is_elevator
    class_eval do |klass|
      
    end
  end

end
