module Ricer4::Plugins::Shadowlamb
  module World::Peine; end
  class World::Peine::StrayDog < Core::Mob
    
    is_real_npc

    # has_algorithm 'attacks,moves,flees'
    
    def sl5_npc_before_definition()
      self.race = get_race(:dog)
      self.gender = get_gender(:male)
      self.playername = 'StrayDog'
      set_npc_boni(
        max_hp: 5,
        attack: 4,
      )
    end

    def sl5_npc_after_spawned_for(party)
    end
    
  end
end
