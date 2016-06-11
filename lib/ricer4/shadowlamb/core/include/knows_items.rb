module Ricer4::Plugins::Shadowlamb::Core
  module Include::KnowsItems
     
    def get_item(name, amount=1)
      item_factory.create(name, amount)
    end

  end
end
