module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Level < ValueType::Combat
    
    def apply_to(player, adjusted)
      player.add_bonus(:attack, player.get_base(:level)) 
    end
    
    def max_base(); get_config(:max_level); end

  end
end
