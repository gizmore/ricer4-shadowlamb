module Ricer4::Plugins::Shadowlamb::Core::Items
  class Present < Openable
    
    def open
      level = owner.level
      power = bot.rand.rand(0, 100)
      item = gift_factory.random_item(level, power)
    end

  end
end
