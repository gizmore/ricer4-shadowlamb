module Ricer4::Plugins::Shadowlamb
  class Equipment < Core::Command
    
    trigger_is :equipment

    requires_player

    has_usage '', function: :_execute_equipment
    
    def _execute_equipment
      execute_equipment(player)
    end
    
    def execute_equipment(player)
      out = []
      player.equipment.items.each do |item|
        out.push(item.display_as_equipment_slot)
      end
      rply(:msg_equipment, equipment: out.join(', '))
    end
      
  end
end
