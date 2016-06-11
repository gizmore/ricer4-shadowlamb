module Ricer4::Plugins::Shadowlamb
  class Stop < Core::Command
    
    trigger_is :stop
    
    works_when :explore, :goto, :move
    
    has_usage  '', function: :_execute_stop
    
    def _execute_stop
      execute_stop(player)
    end
    
    def execute_stop(player)
      party.stop!
    end
    
  end
end
