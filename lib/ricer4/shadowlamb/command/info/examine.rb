module Ricer4::Plugins::Shadowlamb
  class Examine < Core::Command
    
    trigger_is :examine

    requires_player
    
    has_usage  '<sl_near_item>', function: :execute_examine

    def execute_examine(item)
    end
      
  end
end
