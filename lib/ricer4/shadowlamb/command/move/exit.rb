module Ricer4::Plugins::Shadowlamb
  class Exit < Core::Command
    
    trigger_is :exit
    
    def enabled?
      (party.is_inside? && party.location.sl5_can_exit_location?(player, party.location)) rescue false
    end

    requires_leadership
      
    works_when :inside
    
    has_usage '', function: :_execute_exit

    def _execute_exit
      execute_exit(player)
    end
    
    def execute_exit(player)
      player.party.push_action(:knocking)
    end
      
  end
end
