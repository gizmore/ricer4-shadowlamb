module ActiveRecord::Magic::Param
  class SlKnownPlace < ShadowlambParam
    
    def default_options; super.merge({:reachable => true, :same_floor => true}); end
    
    def input_to_value(input)
      parse_param_relation(filter_places(own_player.known_places), input)
    end
    
    def value_to_input(location)
      location.id rescue nil
    end
    
    def filter_places(locations)
      locations = filter_area(locations) if options[:reachable]
      locations = filter_floor(locations) if options[:same_floor]
      locations
    end
    
    def filter_area(locations)
      party = own_party
      locations.select{|location|location.reachable_by?(party)}
    end

    def filter_floor(locations)
      floor = own_party.location.floor rescue own_party.area.floor
      locations.select{|location| location.floor == floor }
    end
    
  end
end
