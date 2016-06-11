module Ricer4::Plugins::Shadowlamb
  class Lvlup < Core::Command
    
    trigger_is :lvlup
    
    requires_player

    has_usage '', function: :_execute_levelup
    def _execute_levelup
      execute_levelup(player)
    end
    def execute_levelup(player)
      
    end
    
  end
end
