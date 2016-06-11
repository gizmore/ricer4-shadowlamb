module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Hp < ValueType::Combat

    arm_subscribe('world/tick/one_minute') do |sender, elapsed|
      player_factory.parties.each do |party|
        if party.is_sleeping?
          party.members.each do |player|
            body = player.get_base(:body)
            player.add_hp(body)
          end
        end
      end
    end
    
    arm_subscribe('world/tick/ten_minutes') do |sender, elapsed|
      player_factory.parties.each do |party|
        party.members.each do |player|
          bodyhp = player.get_adjusted(:bodyhp)
          player.add_hp(bodyhp)
        end
      end
    end
    
  end
end
