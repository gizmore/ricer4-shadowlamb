load File.expand_path("../melee_weapon.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class SwordWeapon < MeleeWeapon
    
    def compute_attack(player)
      attack = player.get_adjusted(:attack)
      attack += self.get_adjusted(:melee)
      attack += self.get_adjusted(:tactic)
      attack += self.get_adjusted(:strength)
      attack += self.get_adjusted(:quickness)
      attack += self.get_adjusted(:swordsman) * 3
      attack
    end
    
    def compute_defend(player)
      attack = player.get_adjusted(:attack)
      attack += self.get_adjusted(:melee)
      attack += self.get_adjusted(:tactic)
      attack += self.get_adjusted(:defense)
      attack += self.get_adjusted(:quickness)
      attack += self.get_adjusted(:swordsman) * 2
    end
    
  end
end
