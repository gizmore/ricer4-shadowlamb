load File.expand_path("../item.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class Mount < Item
    
    def equipment_slot; :mount; end

  end
end
