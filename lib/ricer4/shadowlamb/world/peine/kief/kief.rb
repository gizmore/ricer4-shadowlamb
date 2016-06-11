module Ricer4::Plugins::Shadowlamb
  class World::Peine::Kief < Core::Location
    
    has_location 52.323092, 10.224754
    
    is_shop
    
    buys_items
    
    sells_item  name: "Club",  price: 19.95, chance: 100.0, negotiate: true
    sells_item  name: "Pen",   price: 19.95, chance: 100.0, negotiate: true

  end
end
