module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Quickness < ValueType::Attribute
  
    def apply_to(player, adjusted)
      player.add_bonus(:defense, player.get_base(:quickness))
    end
    
  end
end
