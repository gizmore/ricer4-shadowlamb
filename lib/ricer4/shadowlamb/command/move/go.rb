module Ricer4::Plugins::Shadowlamb
  class Go < Core::Command
    
    trigger_is :go
    
    requires_leadership
      
    works_when :inside, :outside, :knocking, :goto, :explore, :move
    
    def plugin_enabled?
      player.location.floor == player.location.area.floor rescue true
    end
    
    ###################
    ### Coordinates ###
    ###################
    has_usage  '<sl_coordinate>', function: :_execute_go_to
    
    def _execute_go_to(coordinate)
      execute_go_to(party, coordinate)
    end

    def execute_go_to(party, coordinate)
      party.push_action(:move, coordinate)
    end

    #################
    ### Direction ###
    #################
    has_usage  '<sl_direction>', function: :_execute_go_direction
    
    has_usage  '<sl_direction> <sl_distance>', function: :_execute_go_direction
    
    def _execute_go_direction(direction, distance=1000)
      execute_go_direction(party, direction, distance)
    end
    
    def execute_go_direction(party, direction, distance=1000)
      coordinate = direction.transform(party.lat, party.lon, distance)
      execute_go_to(party, coordinate)
    end
    
  end
end
