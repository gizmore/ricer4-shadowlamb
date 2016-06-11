module Ricer4::Plugins::Shadowlamb::Core::Include::HasLocation

  def self.included(base)
    base.extend(Ricer4::Plugins::Shadowlamb::Core::Extend::HasLocation)
  end

  def floor; 0; end
  def is_cellar?; self.floor < 0; end;
  def is_partere?; self.floor == 0; end;
  def width; @width ||= Geocoder::Calculations.radians_to_distance(maxlon-minlon, :km); end
  def height; @height ||= Geocoder::Calculations.radians_to_distance(maxlat-minlat, :km); end
  def squarem; width * height; end
  def squarekm; squarem / 1000; end
  
  def display_coordinates
    "#{self.lat.round(4)}/#{self.lon.round(4)}"
  end
  
  def coordinates
    @coordinates ||= Ricer4::Plugins::Shadowlamb::Core::Coordinate.new(self.lat, self.lon)
  end

  def distance_to(location)
    distance_to_point(location.lat, location.lon)
  end
  
  def distance_to_point(lat, lon)
    distance_between(self.lat, self.lon, lat, lon)
  end
  
  def distance_between(lat1, lon1, lat2, lon2)
    Geocoder::Calculations.distance_between([lat1, lon1], [lat2, lon2], {:units => :km}) * 1000
  end

  def overlaps?(area, check_floor=true)
    area.overlapped_by?(self, check_floor)
  end

  def overlapped_by?(area, check_floor=true)
    ((self.floor == area.floor) || (check_floor == false)) &&
    area.minlat < self.minlat &&
    area.maxlat > self.maxlat &&
    area.minlon < self.minlon &&
    area.maxlon > self.maxlon
  end
  
end
