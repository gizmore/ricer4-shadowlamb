module Ricer4::Plugins::Shadowlamb
  class World::Peine::Peine < Core::City
    
    closed_area

    has_area 52.359236, 10.160684, 52.305528, 10.282907
    
    arm_subscribe('party/moving') do |sender, party|
      every(10.seconds) do
        maybe_mobs_attack(party,
          :Peine/Noob => 10,
          :Peine/Lamer => 40,
          :Peine/SmallOrk => 10,
          :Peine/StrayDog => 20,
        )
      end
    end

  end
end
