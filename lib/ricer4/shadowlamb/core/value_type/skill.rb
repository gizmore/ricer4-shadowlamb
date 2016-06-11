module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Skill < ValueName

    def default; -1; end
    def priority; 10; end
    def section; :skill; end
    
  end
end
