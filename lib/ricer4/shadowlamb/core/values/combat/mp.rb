module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Mp < ValueType::Combat

    arm_subscribe('player/after/sleeping') do |sender, player, elapsed|
    end

  end
end
