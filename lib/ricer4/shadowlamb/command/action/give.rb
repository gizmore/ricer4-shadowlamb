module Ricer4::Plugins::Shadowlamb
  class Give < Core::Command
    
    is_combat_trigger :give
    
    works_always
    
    requires_retype
    
#    has_usage  '<sl_near_player> <sl_nuyen>', function: :_execute_give_nuyen
    has_usage  '<sl_near_player> <sl_inventory_item>', function: :_execute_give_items

    def _execute_give_items(receiver, items)
      execute_give(player, reveiver, items)
    end
    
    def execute_give_items(giver, receiver, items)
      combat_command(giver) do
        if execute_giving_items(giver, receiver, items)
          giver.busy(give_time(giver, receiver, items))
        end
      end
    end
    
    def execute_giving_items(giver, receiver, items)
      weight_before = Core::ItemList.weight(items)
      giver.sl5_on_player_gives_items(giver, receiver, items)
      receiver.sl5_on_player_receives_items(giver, receiver, items)
      arm_publish('player/gives/items', giver, receiver, items)
      weight_before < Core::ItemList.weight(items)
    end
    
    def give_time(giver, receiver)
      return rand(40, 100)
    end
    
    
    def execute_random_attack(attacker)
      defender = attacker.enemy_party.members.sample
      execute_attack(attacker, defender) unless defender.nil?
    end
    
  end
end
