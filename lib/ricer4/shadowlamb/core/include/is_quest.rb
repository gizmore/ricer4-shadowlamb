module Ricer4::Plugins::Shadowlamb::Core::Include::IsQuest
  def self.included(base)
    base.extend(Ricer4::Plugins::Shadowlamb::Core::Extend::IsQuest)
  end
end
