module Ricer4::Plugins::Shadowlamb::Core
  class Direction

    include Include::Base
    include Include::Translates
    
    RADIANS = {
        n:  270.0.deg,  s:  90.0.deg,   e:   0.0.deg,   w: 180.0.deg,
       ne:  315.0.deg, se:  45.0.deg,  sw: 135.0.deg,  nw: 225.0.deg,
       
      # nne:  22.5.deg,  nee:   67.5.deg,  see: 112.5.deg,  sse: 157.5.deg,
      # ssw: 202.5.deg,  sww:  247.5.deg,  nww: 292.5.deg,  nnw:  22.5.deg,
    }
    
    def self.direction_symbol?(direction)
      directions.include?(direction)
    end
    
    def self.direction_label(direction)
      t!("shadowlamb.direction.#{direction}") rescue direction.to_s
    end

    def display_name
      self.class.direction_label(@direction)
    end

    def self.directions; RADIANS.keys; end
    def self.parse(input); self.parse!(input) rescue nil; end
    def self.parse!(input)
      input = input.downcase
      directions.each do |symbol|
        if (direction_label(symbol).downcase.gsub('-','') == input) || (symbol.to_s == input)
          return new(symbol)
        end
      end
      raise StandardError("Direction#parse!: direction is not recognized!")
    end
    
    def initialize(direction)
      raise StandardError("Direction#initialize: direction is not recognized!") unless self.class.direction_symbol?(direction)
      @direction = direction.to_sym
    end
    
    def transform_coordinate(coordinate, distance=100)
      transform(coordinate.lat, coordinate.lon, distance)
    end
    
    def radians
      RADIANS[@direction]
    end
    
    def transform(lat, lon, distance=100)
      lat = Coords.transform_lat(lat, lon, Math.sin(radians)*distance)
      lon = Coords.transform_lon(lat, lon, Math.cos(radians)*distance)
      Coordinate.new(lat, lon)
    end

  end
end
