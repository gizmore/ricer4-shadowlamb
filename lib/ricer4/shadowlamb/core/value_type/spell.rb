module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Spell < ValueName
    
    def default; -1; end
    def priority; 20; end
    def section; :spell; end

  end
end
