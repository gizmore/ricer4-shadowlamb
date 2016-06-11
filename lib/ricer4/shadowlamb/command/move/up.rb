module Ricer4::Plugins::Shadowlamb
  class Up < Core::Command
    
    trigger_is :up
    
    requires_leadership
      
    works_when :inside
    
    def plugin_enabled?
      player.location.class.instance_variable_defined?(:@sl5_has_up_stairs)
    end
    
    has_usage '', function: :_execute_up
    
    def _execute_up
      execute_up(player)
    end
    
    def execute_up(player)
      player.party.raise_floor(1)
    end
    
  end
end
