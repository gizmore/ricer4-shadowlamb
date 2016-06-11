module Ricer4::Plugins::Shadowlamb
  class Enter < Core::Command
    
    trigger_is :enter
    
    requires_leadership
      
    works_when :parking
    
    has_usage '', function: :_execute_enter

    def _execute_enter
      execute_enter(player.party)
    end
    
    def execute_enter(party)
      party.push_action(:knocking)
    end
      
  end
end
