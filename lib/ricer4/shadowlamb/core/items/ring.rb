load File.expand_path("../jewelry.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class Ring < Jewelry
    
    def equipment_slot; :ring; end

    def equipment_max_count(player); 2; end

  end
end
