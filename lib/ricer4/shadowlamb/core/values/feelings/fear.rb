module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Fear < ValueType::Feeling
  
    arm_subscribe('player/sleeping') do |sender, player, elapsed|
      player.set_feeling(:fear, 0)
    end
    
    arm_subscribe('player/tick/minute') do |sender, player, elapsed|
      player.add_feeling(:fear, -elapsed)
    end

  end
end
