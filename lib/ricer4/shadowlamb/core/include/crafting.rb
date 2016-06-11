module Ricer4::Plugins::Shadowlamb::Core::Include::Crafting

  def self.included(base)
    base.extend Ricer4::Plugins::Shadowlamb::Core::Extend::Crafting
  end
  
  ### Dicing
end
