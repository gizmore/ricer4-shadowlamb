module Ricer4::Plugins::Shadowlamb::Core
  class Races::Vampire < HumanRace
    
    arm_subscribe('player/created') do |sender, player|
    end
    
  end
end
