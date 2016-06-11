module Ricer4::Plugins::Shadowlamb::Core
  class StationaryNpc < Npc
    
    def is_mob?; false; end
    def is_real_npc?; false; end
    def is_stationary?; true; end

   
  end
end
