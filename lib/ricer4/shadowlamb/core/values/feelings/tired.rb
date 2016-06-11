module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Tired < ValueType::Feeling
  
    arm_subscribe('player/sleeping') do |sender, player, elapsed|
      player.add_feeling(:tired, -1 * elapsed)
    end
    
    arm_subscribe('player/tick/minute') do |sender, player, elapsed|
    end

  end
end
