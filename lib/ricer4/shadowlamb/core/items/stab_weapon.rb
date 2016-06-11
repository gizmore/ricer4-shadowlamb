load File.expand_path("../melee_weapon.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class StabWeapon < MeleeWeapon
    
    def compute_attack(player, percent)
      attack = player.get_adjusted(:attack)
      attack += self.get_adjusted(:melee)
      attack += self.get_adjusted(:quickness)
      attack += self.get_adjusted(:strength)
      attack
    end

  end
end