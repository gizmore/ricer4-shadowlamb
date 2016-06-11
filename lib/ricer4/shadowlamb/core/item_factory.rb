module Ricer4::Plugins::Shadowlamb::Core
  class ItemFactory
    
#    include Singleton
    def self.instance; @instance ||= self.new; end
    
    include Include::Base
    include Include::Dice
    include Include::KnowsItems
    
    #################
    ### Validator ###
    #################    
    def validate_yaml_items!(identifier, section, items)
      Array(items).each do |gmi_item_string|
        begin
          item = item_factory.from_gmi(gmi_item_string)
          
          if section == 'equipment'
            unless item.is_a?(Ricer4::Plugins::Shadowlamb::Core::Items::Equipment)
              raise Ricer4::ConfigException.new("#{identifier} has equipment that is not equipment: #{gmi_item_string}")
            end
          elsif section == 'cyberware'
            unless item.is_a?(Ricer4::Plugins::Shadowlamb::Core::Items::Cyberware)
              raise Ricer4::ConfigException.new("#{identifier} has cyberware that is not cyberware: #{gmi_item_string}")
            end
          elsif (section == 'inventory') || (section == 'base_loot')
            unless item.collectable?
              raise Ricer4::ConfigException.new("#{identifier} has #{section} items that cannot be put in inventory: #{gmi_item_string}")
            end
          end
#        rescue SystemExit, Interrupt
#          raise
        rescue StandardError => e
          puts "\n#{e.to_s}\n#{e.backtrace}\n\n"
          raise Ricer4::ConfigException.new("#{identifier} has an invalid #{section} item: #{gmi_item_string}\nBECAUSE: #{e.to_s}")
        end
      end
    end
    
    def validate_shop_item_hash!(item_hash)
      item_hash.is_a?(Hash) or raise Ricer4::ConfigException.new("#{item_hash.inspect} is no hash!")
      item_name = item_hash[:name] or raise Ricer4::ConfigException.new("#{item_hash.inspect} has no name!")
      item_klass = ItemName.get_item_const(item_name) or raise Ricer4::ConfigException.new("#{item_hash.inspect} has an unknown item name!")
      shop_keys = [:negotiate, :price, :chance, :name, :amount]
      item_hash.each do |k,v|
        if shop_keys.include?(k)
        elsif value_name = ValueName.get_value_name(k)
        else
          raise Ricer4::ConfigException.new("#{item_hash.inspect} has an unknown value: #{k}")
        end
      end
    end

    ################
    ### Creation ###
    ################
    def from_gmi(arg)
#      arg = arg.downcase
      if /^\d+%/.match(arg)
        arg = arg.substr_from('%')
      end
      amount = 1
      if /^\d+x/.match(arg)
        amount = arg.substr_to('x').to_i
        arg = arg.substr_from('x')
      end
      with = rune_appendix
      runestring = arg.substr_from(with)
      arg = arg.substr_to(with) unless runestring.nil?
      item = create(arg, amount)
      create_runes(item, runestring) unless runestring.nil?
      item
    end
    
    def from_shop_data(item_data)
      item = from_gmi("#{item_data[:amount]}x#{item_data[:name]}")
      item.instance_variable_set(:@sl5_buy_price, item_data[:price]||item.get_base(:worth))
      item
    end
    
    def create_runes(item, runestring)
      runestring.split(',').each do |pair|
        pair = pair.split(':')
        key, bonus_value = pair[0], pair[1]
        raise Ricer4::ExecutionException.new("ItemFactory#create_runes(#{runestring}) has an invalid rune bonus value: #{key}:#{value}") unless bonus_value.integer?
        value = ValueName.get_value_name_i18n(key)
        raise Ricer4::ExecutionException.new("ItemFactory#create_runes(#{runestring}) has an invalid value_key: #{key}:#{value}") if value.nil?
        item.add_bonus(value.value_key, bonus_value.to_i)
      end
    end
    
    def create(name, amount=1)
      raise Ricer4::ExecutionException.new("ItemFactory#create has an invalid amount: #{amount}") unless amount.integer? && amount.between?(1, 30000)
      item_klass = ItemName.get_item_const(name)
      raise Ricer4::ExecutionException.new("ItemFactory#create with unknown item_name: #{name}") if item_klass.nil?
      stackable = ItemName.get_item_stackable(name)
      raise Ricer4::ExecutionException.new("ItemFactory#create amount is given for non stackable: #{amount}x#{name}") if (!stackable) && (amount > 1)
      bot.log.debug("Creating Item #{name} with amount #{amount}")
      item = item_klass.new({item_name: ItemName.get_item_name(name), amount: amount})
      create_base_values(item, name)
    end
    
    def base_values(name)
      ItemName.get_item_values(name) or raise Ricer4::ExecutionException.new("ItemFactory#base_values could not find item: #{name}")
    end
    
    def create_base_values(item, name)
      base_values(name).each do |k,v|
        item.add_base(k, dice_item_value(v))
      end
      item
    end

    ################################
    ### Mob Equipment Generation ###
    ################################
    def create_equipment(gmi_string)
      items = create_items(dice_multiple_of(gmi_string))
      filter_create_equipment_items(items)
    end
    
    def filter_create_equipment_items(items)
      slots, need_redice = [], false
      items.each do |item|
        slot = item.equipment_slot
        if slots.include?(slot)
          need_redice = true
        else
          slots.push(item)
        end
      end
      return items unless need_redice
      
      new_items = [] 
      slots.each do |slot|
        new_items.push(filter_create_equipment_slot(items, slot))
      end
    end
    
    def items_for_slot(items, slot)
      items.select do |item|; item.equipment_slot == slot; end
    end

    def filter_create_equipment_slot(items, slot)
      items_for_slot(item slot).sample
    end

    def create_inventory(gmi_string)
      create_items(dice_multiple_of(gmi_string))
    end

    def create_cyberware(gmi_string)
      create_items(dice_multiple_of(gmi_string))
    end
    
    def create_items!(gmi_strings); create_items(gmi_string, true); end
    def create_items(gmi_strings, raise=false)
      back = []
      Array(gmi_strings).each do |gmi_string|
        begin
          back.push(from_gmi(gmi_string))
        rescue StandardError => e
          bot.log.exception(e)
          raise if raise
        end
      end
      back
    end
    
    ####################
    ### Optimization ###
    ####################
    def optimize_items(items)
      remove = []
      items.each_with_index do |item, i|
        puts "#{item.display_name} is item #{i}"
        if item.stackable?
          items[(i+1)..-1].each do |pitem|
            puts "#{pitem.display_name} is item."
            if (item.item_name_id == pitem.item_name_id) && (pitem.amount > 0)
              item.add_amount(pitem.amount)
              pitem.amount = 0
              remove.push(pitem)
            end
          end
        end
      end
      remove.each{|item|items.destroy(item)}
      items
    end
    
    ###############
    ### Looting ###
    ###############
    def create_loot_for(killer, victim, with)
      items, party = [], killer.party
      items += victim.sl5_on_killed_items(killer, victim, with)
      items += party.sl5_on_killed_items(killer, victim, with)
      items += party.area.sl5_on_killed_items(killer, victim, with)
      items += party.location.sl5_on_killed_items(killer, victim, with)
      create_loot(items)
    end

    def create_loot(*items)
      loot = []
      items.each do |gmi_string|
        if gmi_string.is_a?(Item)
          loot.push(gmi_string) # Already item!
        else
          loot += dice_loots(gmi_string) # Mob dice loot
        end
      end
      optimize_items(loot)
    end
    
    # Split and listify
    def dice_loots(gmi_strings)
      loot = []
      Array(gmi_strings.split(',')) do |gmi_string|
        item = dice_loot(gmi_string)
        loot.push(item) unless item.nil?
      end
      loot
    end
    
    # Dice and create     
    def dice_loot(gmi_string)
      percent = 100.0
      if /^\d+%/.match(arg)
        percent = arg.substr_to('%').to_f
        arg = arg.substr_from('%')
      end
      return nil unless dice_percent(percent)
      from_gmi(gmi_string)
    end

    
  end
end
