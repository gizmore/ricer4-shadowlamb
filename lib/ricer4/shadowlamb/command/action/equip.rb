module Ricer4::Plugins::Shadowlamb
  class Equip < Core::Command
    
    is_combat_trigger :equip
    
    works_always
    
    has_usage  '<sl_inventory_item>', function: :_execute_equip
    
    def _execute_equip(item)
      return rply :err_no_equipment, item: item.display_name unless item.is_equipment?
      item.check_requirements!(player)
      if player.has_max_equipped?(item.equipment_slot)
        execute_unequip_equip(player, item)
      else
        execute_equip(player, item)
      end
    end
    
    def execute_unequip_equip(player, new_item)
      combat_command(player) do
        old_item = player.equipped(new_item.equipment_slot)
        player.busy(old_item.unequip_time + new_item.equip_time)
        old_item.switch_item_list(player.inventory)
        new_item.switch_item_list(player.equipment)
        player.party.send_message_with_busy(player, :msg_changed,
          old_item: old_item.display_name,
          new_item: new_item.display_name,
          slot: new_item.display_equipment_slot
        )
      end
    end

    def execute_equip(player, new_item)
      combat_command(player) do
        player.busy(new_item.equip_time)
        new_item.switch_item_list(player.equipment)
        player.party.send_message_with_busy(player, :msg_equipped,
          new_item: new_item.display_name,
          slot: new_item.display_equipment_slot
        )
      end
    end
    
  end
end
