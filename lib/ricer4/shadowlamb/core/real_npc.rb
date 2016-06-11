module Ricer4::Plugins::Shadowlamb::Core
  class RealNpc < StationaryNpc

    def is_mob?; false; end
    def is_real_npc?; true; end
    def is_stationary?; false; end
   
  end
end
