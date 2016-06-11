module Ricer4::Plugins::Shadowlamb
  class Drop < Core::Command
    
    is_combat_trigger :drop
    
    works_always
    
    requires_retype :always => false
      
    has_usage  '<sl_inventory_item>', function: :_execute_drop
    
    def _execute_drop(items)
      byebug
      if retyped?
        execute_drop(player, items)
      else
        execute_preview(player, items)
      end
    end
    
    def execute_preview(player, items)
      execute_retype!(t(:msg_about_to_drop, items: display_selected_items(items)))
    end
    
    def execute_drop(player, items)
      combat_command do
#        player.remove_items(items)
        rply :msg_dropped, items: display_items(items)
      end
    end
      
  end
end
