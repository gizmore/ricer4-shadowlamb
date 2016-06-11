module Ricer4::Plugins::Shadowlamb
  class Use < Core::Command
    
    is_combat_trigger :use
    
    works_always

    has_usage  '<sl_inventory_item> <sl_near_player>', function: :_execute_use
    has_usage  '<sl_equipment_item> <sl_near_player>', function: :_execute_use
    has_usage  '<sl_inventory_item>', function: :_execute_use
    has_usage  '<sl_equipment_item>', function: :_execute_use
    def _execute_use(item, target=nil)
      execute_use(player, item, target||player)
    end
    
    def execute_use(user, item, target)
      
      
      
    end
    
  end
end
