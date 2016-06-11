module Ricer4::Plugins::Shadowlamb
  class Inventory < Core::Command
    
    requires_player

    is_list_trigger :inventory, :for => Core::Item, :order => 'updated_at'

    def visible_relation(relation)
      relation.where(:item_list => player.inventory)
    end
  
    def search_relation(relation, arg)
      relation.where(:item_list => player.inventory)
    end
      
  end
end
