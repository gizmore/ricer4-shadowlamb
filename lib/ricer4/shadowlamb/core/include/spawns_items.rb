module Ricer4::Plugins::Shadowlamb::Core::Include::SpawnsItems
  
  def self.included(base)
    base.extend Ricer4::Plugins::Shadowlamb::Core::Extend::SpawnsItems
  end
  
  def get_item_npc_yml()
  end

  def get_items_npc_yml(array)
    array.each do |item_name|
    end
  end
  
  def get_item_gmi(arg)
    item_factory.from_gmi(arg)
  end
  
  def get_item(name, amount=1)
    item_factory.create(name, amount)
  end
  
end
