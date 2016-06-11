load File.expand_path("../melee_weapon.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class BluntWeapon < MeleeWeapon
    
    def compute_attack(player)
      attack  = player.get_adjusted(:attack) * 2
      attack += player.get_adjusted(:melee)
      attack += player.get_adjusted(:tactic)
      attack += player.get_adjusted(:strength)
      attack += (self.get_adjusted(:weight) / 100).to_i
      attack
    end
    
    def compute_defend(player)
      attack  = player.get_adjusted(:attack)
      attack += player.get_adjusted(:defense)
      attack += player.get_adjusted(:quickness)
      attack += player.get_adjusted(:melee)
      attack += player.get_adjusted(:tactic)
    end
    
  end
end
