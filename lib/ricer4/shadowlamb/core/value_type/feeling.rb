module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Feeling < ValueName

    def priority; 70; end
    def section; :feeling;  end
    
    def max_base; 0; end
    def max_bonus; 10000; end
    def max_adjusted; 10000; end

  end
end
