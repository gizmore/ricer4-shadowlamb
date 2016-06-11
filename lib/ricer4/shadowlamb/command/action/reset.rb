module Ricer4::Plugins::Shadowlamb
  class Reset < Core::Command
    
    trigger_is :reset
    
    works_when_idle
    
    works_when_alone

    requires_confirmation
      
    has_usage '', function: :execute_reset
    
    def execute_reset
      player.destroy_player!
      rply :msg_reset
    end
      
  end
end
