module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Charisma < ValueType::Attribute
    
    rune_fits_in Items::Helmet,    :match => 100, :max =>  80 
    rune_fits_in Items::Jewelry,   :match => 100, :max => 100, :price => 250
    rune_fits_in Items::Equipment, :match => 100, :max =>  60
    
    craft_looting Items::Equipment, :chance => 100, :max => 100

    def apply_to(player, adjusted)
    end
    
  end
end
