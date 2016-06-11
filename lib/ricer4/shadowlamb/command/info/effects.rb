module Ricer4::Plugins::Shadowlamb
  class Effects < Core::Command
    
    trigger_is :effects
    
    requires_player

    has_usage '', function: :_execute_effects
    
    def _execute_effects
      execute_effects(player)
    end
    
    def execute_effects(player) 
      out = []
      player.effects.each do |value|
        out.push("#{value.to_label}: #{value.adjusted_value}")
      end
      rply :msg_feelings, out: out.join(', ')
    end
      
  end
end
