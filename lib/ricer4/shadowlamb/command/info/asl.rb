module Ricer4::Plugins::Shadowlamb
  class Asl < Core::Command
    
    trigger_is :asl
    
    requires_player

    has_usage '', function: :_execute_status
    
    def _execute_status
      execute_status(player)
    end
    
    def execute_status(players)
      out = []
      player.values.each do |value|
        if value.section_is?(:combat)
          out.push("#{value.to_label}: #{value.base_value}(#{value.adjusted_value})")
        end
      end
      rply :msg_status, out: out.join(', ')
    end
      
  end
end
