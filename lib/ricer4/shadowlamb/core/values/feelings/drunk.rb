module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Drunk < ValueType::Feeling
  
    arm_subscribe('player/sleeping') do |sender, player, elapsed|
      player.add_feeling(:drunk, -elapsed.to_i)
    end
    
    arm_subscribe('player/tick/minute') do |sender, player, elapsed|
      player.add_feeling(:drunk, -elapsed.to_i)
    end

  end
end
