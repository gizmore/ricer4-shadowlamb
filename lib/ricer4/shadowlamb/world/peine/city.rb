module Ricer4::Plugins::Shadowlamb
  class World::Peine::City < Core::Area
    
    has_area 52.332284, 10.226458, 52.309515, 10.252894  
    
    arm_subscribe('party/moving') do |sender, party|
      
      every(30.seconds, party) do
        
        maybe_found_wallet(party)
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
