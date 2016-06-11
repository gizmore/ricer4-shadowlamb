module Ricer4::Plugins::Shadowlamb::Core
  class Coords
    
    def self.transform_lat(lat, lon, meters)
      lat_1r_meters = 111132.954 - 599.822 * Math.cos((lat*2).deg) + 1.175 * Math.cos((lat*4).deg)
      lat + meters / lat_1r_meters
    end

    def self.transform_lon(lat, lon, meters)
      lon_1r_meters = (Math::PI / 180) * 6367445 * Math.cos(lat.deg)
      lon + meters / lon_1r_meters
    end
    
  end
end
