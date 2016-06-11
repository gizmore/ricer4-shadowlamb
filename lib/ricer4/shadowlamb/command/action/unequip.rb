module Ricer4::Plugins::Shadowlamb
  class Unequip < Core::Command
    
    is_combat_trigger :unequip

    has_usage  '<sl_equipment_item>', function: :_execute_unequip
    
    def _execute_unequip(item)
      execute_unequip(player, item)
    end
    
    def execute_unequip(player, old_item)
      combat_command(player) do
        player.busy(old_item.unequip_time)
        old_item.switch_item_list(player.inventory)
        player.party.send_message_with_busy(player, :msg_unequipped, old_item: item.display_name)
      end
    end
      
  end
end
