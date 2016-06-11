module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Body < ValueType::Attribute
    
    # Defensive items to craft
    rune_fits_in Items::Armor,  :match => 100
    rune_fits_in Items::Shield, :match =>  40
    rune_fits_in Items::Legs,   :match =>  30
    
    # Loots in any equipment, but you cannot upgrade :P
    craft_looting Items::Armor,     :chance => 100
    craft_looting Items::Equipment, :chance =>  50
    
  end
end
