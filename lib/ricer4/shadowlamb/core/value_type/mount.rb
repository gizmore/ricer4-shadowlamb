module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Mount < ValueName

    def default; 0; end
    def priority; 40; end
    def section; :mount; end
    
    rune_fits_in Items::Mount,  :match => 100

  end
end
