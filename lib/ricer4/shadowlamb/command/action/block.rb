module Ricer4::Plugins::Shadowlamb
  class Block < Core::Command
    
    is_combat_trigger :block
    
    works_when :fighting
    
    has_usage '', function: :_execute_block
    
    def _execute_block
      execute_block(player)
    end
    
    def execute_block(attacker)
      combat_command(attacker) do
#        attacker.busy(5)
      end
    end
    
  end
end
