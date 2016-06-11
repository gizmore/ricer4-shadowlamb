module Ricer4::Plugins::Shadowlamb::Core
  class Coordinate

    include Include::Base
    include Include::Translates
    include Include::HasLocation
    
    def initialize(lat, lon)
      @lat, @lon = lat, lon
    end
    
    ###################
    ### HasLocation ###
    ###################
    # def radius; 0.0000001; end
    def    lat; @lat; end; def    lon; @lon; end
    def minlat; @lat; end; def minlon; @lon; end
    def maxlat; @lat; end; def maxlon; @lon; end

    ##############
    ### Parser ###
    ##############    
    def self.parse(input); parse!(input) rescue nil; end
    
    def self.parse!(input)
      tuple = input.split(',')
      raise Ricer4::ExecutionException.new("Coordinate::parse! - Invalid lat,lon: #{input}") unless tuple.count == 2
      lat, lon = tuple[0].to_f, tuple[1].to_f
      raise Ricer4::ExecutionException.new("Coordinate::parse! - Invalid lat: #{lat}") unless lat.between?(-90, 90)
      raise Ricer4::ExecutionException.new("Coordinate::parse! - Invalid lon: #{lon}") unless lon.between?(-180, 180)
      new(lat, lon)
    end

    def self.valid?(lat, lon)
      lat.between?(-90,90) && lon.between?(-180,180)
    end
    
    def self.display(lat, lon)
      t!("shadowlamb.coordinates", lat: lat, lon: lon) rescue "#{lat},#{lon}"
    end
    
    def valid?
      self.class.valid?(@lat, @lon)
    end
    
    ###############
    ### Display ###
    ###############
    def to_string; "#{lat.round(6)},#{lon.round(6)}"; end
    def display_name; self.class.display(@lat, @lon); end

  end
end
