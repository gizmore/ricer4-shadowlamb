module Ricer4::Plugins::Shadowlamb::Core
  module Include::HasItems
     
    include Ricer4::Plugins::Shadowlamb::Core::Include::KnowsItems
    
    def self.included(base)
      base.extend(Ricer4::Plugins::Shadowlamb::Core::Extend::HasItems)
    end
    
  end
end
