load File.expand_path("../weapon.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class FirearmsWeapon < Weapon
    
    def compute_armor(player)
      return player.get_adjusted(:farm)
    end
    
  end
end
