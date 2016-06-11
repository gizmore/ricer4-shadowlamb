module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Thirst < ValueType::Feeling
  
    arm_subscribe('player/consumed/drink') do |sender, player, item|
      player.add_feeling(:thirst, -item.get_adjusted(:thirst))
    end
    
    arm_subscribe('player/tick/five_minutes') do |sender, player, elapsed|
      ouchy!(player) if thirsty?(player)
      2.times { ouchy!(player) } if parching?(player)
      player.add_feeling(:thirst, 10*elapsed)
    end
    
    def self.ouchy!(player)
      player.add_hp(-1)
    end

    def self.thirsty?(player)
      player.get_feeling(:thirst) > 7500 
    end

    def self.parching?(player)
      player.get_feeling(:thirst) > 9000 
    end
    
  
  end
end
