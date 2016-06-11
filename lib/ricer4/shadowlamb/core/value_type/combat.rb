module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Combat < ValueName

    def default; 0; end
    def priority; 10; end
    def section; :combat; end
    
    def max_base; 0; end
    def max_bonus; 10000; end
    def max_adjusted; 10000; end

  end
end
