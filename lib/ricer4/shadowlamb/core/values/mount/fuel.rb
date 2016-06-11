module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Fuel < ValueType::Mount
    
    arm_subscribe('party/action/move') do |sender, party, elapsed, distance|
      party.members.each do |player|
        player.mount.add_base(:fuel, -elapsed)
      end
    end
    
  end
end
