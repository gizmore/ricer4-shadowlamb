module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Wealth < ValueName

    def default; 0; end
    def priority; 50; end
    def section; :wealth; end
    
    def max_base; 0; end
    def max_bonus; 1000000000; end
    def max_adjusted; 1000000000; end

  end
end
