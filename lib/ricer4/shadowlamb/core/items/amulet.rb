load File.expand_path("../jewelry.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class Amulet < Jewelry
    
    def equipment_slot; :amulet; end

  end
end
