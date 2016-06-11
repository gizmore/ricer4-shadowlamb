module Ricer4::Plugins::Shadowlamb
  class Down < Core::Command
    
    trigger_is :down
    
    requires_leadership
      
    works_when :inside, :parking
    
    def plugin_enabled?
      player.location.class.instance_variable_defined?(:@sl5_has_down_stairs) &&
        Array(player.location.class.instance_variable_get(:@sl5_has_down_stairs)).include?(player.party.action_sym.to_sym)
    end
    
    has_usage '', function: :_execute_down
    
    def _execute_down
      execute_down(player)
    end
    
    def execute_down(player)
      player.party.raise_floor(-1)
    end
    
  end
end
