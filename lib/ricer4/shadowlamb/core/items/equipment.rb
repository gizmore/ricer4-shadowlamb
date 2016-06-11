load File.expand_path("../item.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class Equipment < Item
  
    def equipment_max_count(player); 1; end

    def equip_time
      (get_weight / 20).to_i
    end

    def unequip_time
      (get_weight / 45).to_i
    end
    
    ############
    ### I18n ###
    ############
    def equipment_slot; raise Ricer4::ConfigException.new("Equipment has no slot defined!"); end
    def equipment_slot_long; t("shadowlamb.equipment.slot_long.#{equipment_slot}"); end
    def equipment_slot_short; t("shadowlamb.equipment.slot_short.#{equipment_slot}"); end
    def display_equipment_slot; "\x02#{equipment_slot_long}\x02"; end
    def display_as_equipment_slot; self.display_equipment_slot + ": " + self.display_name; end
    
  end
end
