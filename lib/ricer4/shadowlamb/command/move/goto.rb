module Ricer4::Plugins::Shadowlamb
  class Goto < Core::Command
    
    trigger_is :goto
    
    requires_leadership
      
    works_when :inside, :outside, :knocking, :goto, :explore, :move 
    
    def plugin_enabled?
      player.location.floor == player.location.area.floor rescue true
    end

    has_usage '<sl_known_place>', function: :_execute_goto

    def _execute_goto(location)
      execute_goto(party, location)
    end

    def execute_goto(party, location)
      party.push_action(:goto, location)
    end
      
  end
end
