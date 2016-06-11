module Ricer4::Plugins::Shadowlamb
  class Attributes < Core::Command
    
    trigger_is :attributes
    
    requires_player

    has_usage '', function: :execute_attributes
    def execute_attributes
      out = []
      player.values.each do |value|
        if value.section_is?(:attribute) && value.is_learned?
          out.push(value.display)
        end
      end
      rply :msg_attributes, out: out.join(', ')
    end
      
  end
end
