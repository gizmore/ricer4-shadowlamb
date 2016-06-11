load File.expand_path("../jewelry.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class Earring < Jewelry
    
    def equipment_slot; :earring; end

    def equipment_max_count(player); 2; end

  end
end
