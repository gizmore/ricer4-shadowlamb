load File.expand_path("../weapon.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class MeleeWeapon < Weapon
    
    def compute_armor(player)
      return player.get_adjusted(:marm)
    end
    
    def compute_attack(player)
      attack  = player.get_adjusted(:attack)
      attack += player.get_adjusted(:melee)
      attack += player.get_adjusted(:ninja) * 3
      attack += player.get_adjusted(:tactic)
      attack += player.get_adjusted(:quickness) * 2
      attack += player.get_adjusted(:strength)
      attack
    end

    def compute_defend(player)
      attack  = player.get_adjusted(:attack)
      attack += player.get_adjusted(:defense)
      attack += player.get_adjusted(:melee)
      attack += player.get_adjusted(:ninja)
      attack += player.get_adjusted(:tactic)
      attack += player.get_adjusted(:quickness) * 2
      attack += player.get_adjusted(:strength)
      attack
    end

  end
end
