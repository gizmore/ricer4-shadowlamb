load File.expand_path("../item_list.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core
  class EquipmentList < ItemList

    ##########################
    ### Equipment specific ###
    ##########################
    def item_in_slot(slot)
      items_in_slot(slot).sample
    end
    
    def items_in_slot(slot)
      items.select {|item| item.equipment_slot == slot }
    end

    def count_items_in_slot(slot)
      items.count {|item| item.equipment_slot == slot }
    end
    
    def check_dup_equips!
      self.items.each{|item|check_dup_equip!(item)}
    end

    def check_dup_equip!(item)
      slot = item.equipment_slot
      count, max_count = count_items_in_slot(slot), item.equipment_max_count(item.owner)
      if count > max_count
        remove_item(item)
        bot.log.exception(StandardError.new("EquipmentList#check_dup_equip!(#{item.display_name}): you already have #{count} #{slot} equipped!"))
      end
    end
    
    ################
    ### Override ###
    ################
    # def add_items(items)
      # Array(items).each{|item|
        # raise StandardError("EquipmentList#add_item(#{item.display_name}): is not an equipment!") unless item.is_a?(Items::Equipment)
      # }
      # super(items)
    # end
    
  end
end
