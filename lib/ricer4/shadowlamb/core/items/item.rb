load File.expand_path("../../item.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class Item < Ricer4::Plugins::Shadowlamb::Core::Item
    
    def sellable?; true; end
    def collectable?; true; end
    
    def get_weight; get_bonus(:weight); end

    def apply_equipment_to(player)
      apply_values_to(player)
    end

    def apply_inventory_to(player)
      apply_weight_to(player)
    end

    def apply_weight_to(player)
      player.add_bonus(:carry, self.get_adjusted(:weight))
    end
    
    def apply_values_to(player)
    end

  end
  
  Item.extend Ricer4::Plugins::Shadowlamb::Core::Extend::IsStaticItem
  
end
