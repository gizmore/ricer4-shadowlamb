load File.expand_path("../melee_weapon.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class NinjaWeapon < MeleeWeapon
    
    def compute_attack(player)
      attack  = player.get_adjusted(:attack)
      attack += player.get_adjusted(:melee)
      attack += player.get_adjusted(:ninja) * 3
      attack += player.get_adjusted(:tactic)
      attack += player.get_adjusted(:quickness)
      attack += player.get_adjusted(:strength)
      attack
    end

    def compute_defend(player)
      attack  = player.get_adjusted(:attack)
      attack += player.get_adjusted(:melee)
      attack += player.get_adjusted(:ninja) * 3
      attack += player.get_adjusted(:tactic)
      attack += player.get_adjusted(:quickness)
      attack += player.get_adjusted(:strength)
      attack
    end

  end
end