load File.expand_path("../quest_item.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class UniqueQuestItem < QuestItem
    
    def sellable?; false; end
    def dropable?; false; end
    def tradable?; false; end

  end
end
