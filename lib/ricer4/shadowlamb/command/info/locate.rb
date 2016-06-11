module Ricer4::Plugins::Shadowlamb
  class Locate < Core::Command
    
    trigger_is "sr.locate"
    
    requires_player
    
    has_usage '', function: :_execute_locate
    def _execute_locate()
      execute_locate(player.party)
    end
    
    def execute_locate(party)
      rply :msg_located, area: party.area.display_name, coords: party.display_coordinates
    end
      
  end
end
