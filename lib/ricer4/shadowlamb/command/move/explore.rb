module Ricer4::Plugins::Shadowlamb
  class Explore < Core::Command
    
    trigger_is :explore

    requires_leadership
      
    works_when :inside, :outside, :knocking, :goto, :explore, :move 

    def plugin_enabled?
      player.location.floor == player.location.area.floor rescue true
    end

    has_usage '', function: :_execute_explore
    
    def _execute_explore
      execute_explore(player)
    end
      
    def execute_explore(player)
      byebug
      # Get unknown location as possible target
      area = player.party.area
      
      possible = area.locations.select{|location|!player.knows?(location)}
      possible = rand_item(possible)

      coordinates = possible ? possible.coordinates : area.random_coordinates

      player.party.push_action(:explore, coordinates)
    end

  end
end
