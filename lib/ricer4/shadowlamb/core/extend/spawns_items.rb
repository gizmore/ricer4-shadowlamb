module Ricer4::Plugins::Shadowlamb::Core::Extend::SpawnsItems
  
  def get_item_gmi(arg)
    item_factory.from_gmi(arg)
  end
  
  def get_item(name, amount=1)
    item_factory.create(name, amount)
  end
  
end
