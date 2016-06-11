module Ricer4::Plugins::Shadowlamb::Core
  class Mob < Npc

    def is_mob?; true; end
    def is_real_npc?; false; end
    def is_stationary?; false; end
    
    def save!(options={})
      puts "HERE"
      byebug
      puts "HERE"
      true
    end

    def save_player!
      true
    end

    def destroy_player!
      player_factory.remove_mob(self)
    end
   
    def respawn!
      party.remove_member(self)
      self.destroy_player!
      player_factory.remove_party(self.party) if party.dead?
    end
  end
end
