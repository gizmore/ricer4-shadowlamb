module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Frozen < ValueType::Effect
  
    arm_subscribe('player/before/fighting') do |player, elapsed|
      if player.has_effect?(:frozen)
        player.add_effect(:frozen, -elapsed)
        player.busy(elapsed)
      end
      
    end

  end
end
