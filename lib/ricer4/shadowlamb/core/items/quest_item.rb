load File.expand_path("../item.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class QuestItem < Item
    
    def sellable?; false; end

  end
end
