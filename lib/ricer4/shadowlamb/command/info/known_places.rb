module Ricer4::Plugins::Shadowlamb
  class KnownPlaces < Core::Command
    
    trigger_is :kp
    
    requires_player
    
    has_usage  '', function: :execute_known_places
    has_usage  '<sl_area>', function: :execute_known_places_area
    
    def execute_known_places()
      execute_known_places_area(player.party.area)
    end
      
    def execute_known_places_area(area)
      places = []
      floor = player.party.floor
      player.known_places.each do |location|
        places.push(location) if (location.reachable_by_area?(area)) && (location.floor == floor)
      end
      rply :msg_known_places, area: area.display_name, places: human_join(places)
    end
      
  end
end
