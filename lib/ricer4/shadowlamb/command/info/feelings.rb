module Ricer4::Plugins::Shadowlamb
  class Feelings < Core::Command
    
    trigger_is :feelings
    
    requires_player

    has_usage '', function: :execute_feelings
    def execute_feelings
      out = []
      player.values.each do |value|
        if value.section_is?(:feeling)
          out.push("#{value.to_label}: #{value.adjusted_value}")
        end
      end
      rply :msg_feelings, out: out.join(', ')
    end
      
  end
end
