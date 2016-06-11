module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Effect < ValueName
    
    def default; 0; end
    def priority; 10; end
    def section; :effect; end
    
    def max_base; 0; end
    def max_bonus; 10000; end
    def max_adjusted; 10000; end

  end
end
